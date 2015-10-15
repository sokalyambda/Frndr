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

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _currentPage = 1;
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
    
    [self configureBottomRefreshControl];
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
    
    WEAK_SELF;
    [self loadFriendsListWithPage:1 onSuccess:^(NSArray *friendsList) {
        
        if (friendsList.count) {
            weakSelf.friends = [NSMutableArray arrayWithArray:friendsList];
        }
        
        [weakSelf showHideNoMatchesView];
        
    } onFailure:nil];
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
    self.bottomRefreshControl.additionalVerticalInset = CGRectGetHeight(self.navigationController.navigationBar.frame);
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

- (void)updateLocalFriendsArrayWithArray:(NSArray *)newArray
{
    [self.friends addObjectsFromArray:newArray];
    [self.friendsTableView reloadData];
}

/**
 *  Load more friends relative to current page
 */
- (void)loadFriendsListWithPage:(NSInteger)page
                      onSuccess:(void(^)(NSArray *friendsList))success
                       onFailure:(FailureBlock)failure
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getFriendsListWithPage:page onSuccess:^(NSArray *friendsList) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (success) {
            success(friendsList);
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
//    For testing purposes
    
//    NSMutableArray *friends = [NSMutableArray array];
//    for (int i = 0; i < 3; ++i) {
//        FRDFriend *friend = [[FRDFriend alloc] init];
//        friend.lastMessage = @"AAAKSJJSKLADAIWDIAWLLIAWDAWDILJAWDDWLKJWDIALWIDJW";
//        [friends addObject:friend];
//    }
//    success(friends);
}

/**
 *  for bottom refresh control
 */
- (void)loadMoreFriends
{
    WEAK_SELF;
    [self loadFriendsListWithPage:self.currentPage onSuccess:^(NSArray *friendsList) {
        
        if (friendsList.count) {
            [weakSelf updateLocalFriendsArrayWithArray:friendsList];
        }
        
    } onFailure:nil];
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
            
            //new message received from this friend
            messageOwner.hasNewMessages = YES;
            
            [self.friendsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.friends indexOfObject:messageOwner] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    WEAK_SELF;
    [self loadFriendsListWithPage:1 onSuccess:^(NSArray *friendsList) {
        
        if (friendsList.count) {
            weakSelf.friends = [NSMutableArray arrayWithArray:friendsList];
        }
        
        [weakSelf showHideNoMatchesView];
        
    } onFailure:nil];
}

@end
