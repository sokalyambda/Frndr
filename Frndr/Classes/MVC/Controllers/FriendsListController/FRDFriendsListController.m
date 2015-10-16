//
//  FRDFriendsListController.m
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendsListController.h"
#import "FRDChatController.h"
#import "FRDContainerController.h"

#import "FRDFriendCell.h"
#import "FRDNoMatchesView.h"

#import "FRDProjectFacade.h"

#import "FRDSerialViewConstructor.h"
#import "FRDChatMessagesService.h"

#import "FRDFriend.h"

#import "FRDSeparatedBottomRefreshControl.h"

#import "UIView+MakeFromXib.h"

@interface FRDFriendsListController ()<UITableViewDataSource, UITableViewDelegate, FRDNoMatchesViewDelegate>

@property (nonatomic) NSMutableArray *friends;

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (strong, nonatomic) FRDNoMatchesView *noMatchesView;
@property (weak, nonatomic) IBOutlet UIView *noMatchesViewContainer;

@property (strong, nonatomic) FRDSeparatedBottomRefreshControl *bottomRefreshControl;

@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation FRDFriendsListController

dispatch_queue_t friends_updating_queue() {
    
    static dispatch_queue_t friends_updating_queue;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        friends_updating_queue = dispatch_queue_create("friends_updating_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return friends_updating_queue;
}

@synthesize friends = _friends;

#pragma mark - Accessors

- (FRDSeparatedBottomRefreshControl *)bottomRefreshControl
{
    if (!_bottomRefreshControl) {
        _bottomRefreshControl = [[FRDSeparatedBottomRefreshControl alloc] initWithTableView:self.friendsTableView];
    }
    return _bottomRefreshControl;
}

- (NSString *)titleString
{
    return @"Frnds";
}

- (NSString *)leftImageName
{
    return @"preferencesTopIcon";
}

- (NSString *)rightImageName
{
    return @"";
}

/*****Friends array accessors*****/
- (NSMutableArray *)friends
{
    if (!_friends) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

- (void)setFriends:(NSMutableArray *)friends
{
    _friends = friends;
    [self.friendsTableView reloadData];
}
/*****Friends array accessors*****/

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _currentPage = 2;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.friendsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //for ios 8
    self.friendsTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.friendsTableView.rowHeight = UITableViewAutomaticDimension;
    
    WEAK_SELF;
    [self loadFriendsFirstPageOnSuccess:^(NSArray *friends) {
        [weakSelf updateLastFriendsPageWithFriends:friends];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self subscribeForNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initNoMatchesView];
    [self configureBottomRefreshControl];
    
    WEAK_SELF;
    [self loadFriendsFirstPageOnSuccess:^(NSArray *friends) {
        [weakSelf updateFirstFriendsPageWithFriends:friends];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unsibscribeFromNotifications];
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRDFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FRDFriendCell class]) forIndexPath:indexPath];
    
    [cell configureWithFriend:self.friends[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FRDFriend *currentFriend = self.friends[indexPath.row];
    
    //there are no new messages now
    currentFriend.hasNewMessages = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    FRDChatController *chatController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDChatController class])];
    chatController.currentFriend = currentFriend;

    [self.navigationController pushViewController:chatController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - FRDNoMatchesViewDelegate

- (void)noMatchesViewShouldShowSearchNearestUsersController:(FRDNoMatchesView *)view
{
    if ([self.parentViewController isKindOfClass:[FRDContainerViewController class]]) {
        [((FRDContainerViewController *)self.parentViewController) showNextPreviousController:FRDPresentedControllerTypePrevious];
    }
}

#pragma mark - Actions

/**
 *  Configure bottom refresh control
 */
- (void)configureBottomRefreshControl
{
    [self.bottomRefreshControl addTarget:self action:@selector(loadMoreFriends) forControlEvents:UIControlEventValueChanged];
    self.bottomRefreshControl.additionalVerticalInset = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

/**
 *  Show or hide no matches view
 */
- (void)showHideNoMatchesView
{
    if (!self.friends.count && ![self.noMatchesViewContainer.subviews containsObject:self.noMatchesView]) {
        [self.noMatchesViewContainer addSubview:self.noMatchesView];
        [self.view bringSubviewToFront:self.noMatchesViewContainer];
    } else if (self.friends.count && [self.noMatchesViewContainer.subviews containsObject:self.noMatchesView]) {
        [self.noMatchesView removeFromSuperview];
        [self.view sendSubviewToBack:self.noMatchesViewContainer];
    }
}

/**
 *  Configure no matches view and set the delegate
 */
- (void)initNoMatchesView
{
    if (!self.noMatchesView) {
        self.noMatchesView = [FRDNoMatchesView makeFromXib];
        self.noMatchesView.delegate = self;
        self.noMatchesView.frame = self.noMatchesViewContainer.bounds;
    }
}

- (void)subscribeForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessageNotification:) name:DidReceiveNewMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)unsibscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/**
 *  Update first friends page
 *
 *  @param friends New Friends array
 */
- (void)updateFirstFriendsPageWithFriends:(NSArray *)friends
{
    if (friends.count) {
        @autoreleasepool {
            
            dispatch_async(friends_updating_queue(), ^{
                NSMutableArray *newFriends = [@[] mutableCopy];
                
                FRDFriend *currentFirstFriend = self.friends.firstObject;
                
                for (FRDFriend *friend in friends) {
                    
                    if (friend.isNewFriend && [currentFirstFriend.lastMessagePostedDate compare:friend.lastMessagePostedDate] == NSOrderedAscending) {
                        [newFriends addObject:friend];
                    }
                    
                }
                
                [newFriends addObjectsFromArray:self.friends];
                
                [FRDChatMessagesService updateCurrentFriendsLastMessages:self.friends withNewFriendsArray:friends];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.friends = newFriends;
                });
                
            });
            
        }
    }
}

- (void)updateLastFriendsPageWithFriends:(NSArray *)friends
{
    [self.friends addObjectsFromArray:friends];
    [self.friendsTableView reloadData];
}

/**
 *  Load more friends relative to current page
 */
- (void)loadFriendsListWithPage:(NSInteger)page
                      onSuccess:(void(^)(NSArray *friendsList))success
{
    WEAK_SELF;
    if (!self.bottomRefreshControl.isRefreshing) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [FRDProjectFacade getFriendsListWithPage:page onSuccess:^(NSArray *friendsList) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.bottomRefreshControl endRefreshing];
        
        if (success) {
            success(friendsList);
        }
  
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [weakSelf.bottomRefreshControl endRefreshing];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];

    }];
    
//    For testing purposes
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.bottomRefreshControl endRefreshing];
//        static int j = 1;
//        NSMutableArray *friends = [NSMutableArray array];
//        for (int i = 1; i <= 2; ++i) {
//            FRDFriend *friend = [[FRDFriend alloc] init];
//            friend.lastMessage = [NSString stringWithFormat:@"%d %d", j, i];
//            [friends addObject:friend];
//        }
//        j++;
//        NSLog(@"Frieds added");
//        success(friends);
//    });
}

/**
 *  for bottom refresh control
 */
- (void)loadMoreFriends
{
    WEAK_SELF;
    [self loadFriendsListWithPage:self.currentPage onSuccess:^(NSArray *friendsList) {
        
        if (friendsList.count) {
            [weakSelf updateLastFriendsPageWithFriends:friendsList];
            weakSelf.currentPage++;
        }
        
    }];
}

- (void)loadFriendsFirstPageOnSuccess:(void(^)(NSArray *friends))success
{
    [self loadFriendsListWithPage:1 onSuccess:success];
}

#pragma mark - New Messages Handling

- (void)didReceiveNewMessageNotification:(NSNotification *)notification
{
    //Message from socket has ownerId, friendId, messageBody;
    FRDChatMessage *message = (FRDChatMessage *)notification.object;

    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    if ([currentProfile.userId isEqualToString:message.ownerId]) {
        //The message was sent by me
        //It doesn't matter in this screen
    } else {
        //Attempt to find the friend whos ID will be equal to owner ID of new message
        FRDFriend *messageOwner = [FRDChatMessagesService findFriendWithId:message.ownerId inArray:self.friends];
        
        if (messageOwner) {
            messageOwner.lastMessage = message.messageBody;
            messageOwner.lastMessagePostedDate = message.creationDate;
            //new message received from this friend
            messageOwner.hasNewMessages = YES;
            
            [self.friendsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.friends indexOfObject:messageOwner] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Notifications

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    WEAK_SELF;
    [self loadFriendsFirstPageOnSuccess:^(NSArray *friends) {
        [weakSelf updateFirstFriendsPageWithFriends:friends];
    }];
}

@end
