//
//  FRDFriendsListController.m
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendsListController.h"
#import "FRDChatController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDFriendCell.h"

#import "FRDProjectFacade.h"

#import "FRDChatMessagesService.h"

#import "FRDFriend.h"

@interface FRDFriendsListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *friends;

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation FRDFriendsListController

#pragma mark - Accessors

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self subscribeForMessagesNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadFriendsList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unsibscribeFromMessagesNotification];
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

#pragma mark - Actions

- (void)subscribeForMessagesNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessageNotification:) name:DidReceiveNewMessageNotification object:nil];
}

- (void)unsibscribeFromMessagesNotification
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
- (void)loadFriendsList
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getFriendsListWithPage:self.currentPage onSuccess:^(NSArray *friendsList) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (friendsList.count) {
            [weakSelf updateLocalFriendsArrayWithArray:friendsList];
            weakSelf.currentPage++;
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
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

@end
