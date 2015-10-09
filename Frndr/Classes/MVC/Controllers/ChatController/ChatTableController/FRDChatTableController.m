//
//  FRDChatTableController.m
//  Frndr
//
//  Created by Pavlo on 10/5/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatTableController.h"

#import "FRDBaseChatCell.h"

#import "FRDChatMessage.h"
#import "FRDFriend.h"

#import "FRDChatMessagesService.h"

#import "FRDChatCells.h"

@interface FRDChatTableController ()

@end

@implementation FRDChatTableController

@synthesize messageHistory = _messageHistory;

#pragma mark - Accessors 

- (NSMutableArray *)messageHistory
{
    if (!_messageHistory) {
        _messageHistory = [NSMutableArray array];
    }
    return _messageHistory;
}

- (void)setMessageHistory:(NSMutableArray *)messageHistory
{
    _messageHistory = messageHistory;
    [self.tableView reloadData];
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
    
    [self registerCells];
    [self loadChatHistory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self subscribeForMessagesNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unsibscribeFromMessagesNotification];
    [super viewWillDisappear:animated];
}

#pragma mark - Actions

- (void)registerCells
{
    NSString *userChatCellNibName = NSStringFromClass([FRDUserChatCell class]);
    UINib *userChatCellNib = [UINib nibWithNibName:userChatCellNibName bundle:nil];
    [self.tableView registerNib:userChatCellNib forCellReuseIdentifier:userChatCellNibName];
    
    NSString *friendChatCellNibName = NSStringFromClass([FRDFriendChatCell class]);
    UINib *friendChatCellNib = [UINib nibWithNibName:friendChatCellNibName bundle:nil];
    [self.tableView registerNib:friendChatCellNib forCellReuseIdentifier:friendChatCellNibName];
    
    NSString *systemChatCellNibName = NSStringFromClass([FRDSystemChatCell class]);
    UINib *systemChatCellNib = [UINib nibWithNibName:systemChatCellNibName bundle:nil];
    [self.tableView registerNib:systemChatCellNib forCellReuseIdentifier:systemChatCellNibName];
}

/**
 *  Load chat history with current friend
 */
- (void)loadChatHistory
{
    WEAK_SELF;
    if (!self.refreshControl.isRefreshing) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [FRDChatMessagesService getChatHistoryWithFriend:self.currentFriend.userId andPage:self.currentPage onSuccess:^(NSArray *chatHistory) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [weakSelf.refreshControl endRefreshing];
        
        weakSelf.currentPage++;
        
        //set messages array
        NSMutableArray *updatedMessages = [NSMutableArray arrayWithArray:chatHistory];
        [updatedMessages addObjectsFromArray:weakSelf.messageHistory];
        weakSelf.messageHistory = updatedMessages;
        
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf.parentViewController andCompletion:nil];
    }];
}

- (IBAction)loadMoreMessages:(id)sender
{
    [self loadChatHistory];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRDChatMessage *currentMessage = self.messageHistory[indexPath.row];
    
    FRDBaseChatCell *cell = [FRDBaseChatCell chatCellWithOwnerType:currentMessage.ownerType forTableView:tableView atIndexPath:indexPath];
    
    cell.positionInSet = [FRDChatMessagesService positionOfCellInSetByIndexPath:indexPath inMessagesHistory:self.messageHistory];
    
    [cell configureForFriend:self.currentFriend withMessage:currentMessage];
    
    return cell;
}

- (void)subscribeForMessagesNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessageNotification:) name:DidReceiveNewMessageNotification object:nil];
}

- (void)unsibscribeFromMessagesNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - New Messages Handling

- (void)didReceiveNewMessageNotification:(NSNotification *)notification
{
    //Message from socket has ownerId, friendId, messageBody;
    FRDChatMessage *message = (FRDChatMessage *)notification.object;
    
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    
    if ([currentProfile.userId isEqualToString:message.ownerId]) {

        message.ownerType = FRDMessageOwnerTypeUser;
        
    } else if ([self.currentFriend.userId isEqualToString:message.ownerId]) {
        
        message.ownerType = FRDMessageOwnerTypeFriend;
        
    }
    
    message.creationDate = [NSDate date];
    
    [self.messageHistory addObject:message];

    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messageHistory.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

@end
