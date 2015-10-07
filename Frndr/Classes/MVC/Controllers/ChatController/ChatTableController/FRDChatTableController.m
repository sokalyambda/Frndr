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
    
    [self loadChatHistory];
}

#pragma mark - Actions

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

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRDBaseChatCell *cell;
    
    FRDChatMessage *currentMessage = self.messageHistory[indexPath.row];
    
    cell = [FRDBaseChatCell chatCellWithMessage:currentMessage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.positionInSet = [self getPositionOfCellInSetByIndexPath:indexPath inTableView:tableView];
        
        
    });
    if (currentMessage.ownerType == FRDMessageOwnerTypeFriend) {
        [cell configureForFriend:self.currentFriend withMessage:currentMessage];
    } else {
        [cell configureForFriend:nil withMessage:currentMessage];
    }
    return cell;
}

- (FRDChatCellPositionInSet)getPositionOfCellInSetByIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    
    FRDChatMessage *previousMessage;
    FRDChatMessage *nextMessage;
    
    if (nextIndexPath.row < self.messageHistory.count) {
        nextMessage = self.messageHistory[nextIndexPath.row];
    }
    if (previousIndexPath.row >= 0) {
        previousMessage = self.messageHistory[previousIndexPath.row];
    }

    if (!previousMessage && !nextMessage) { //it is the first cell at all
        
        return FRDChatCellPositionInSetFirst;
        
    } else if (!previousMessage && nextMessage) {
        
        return FRDChatCellPositionInSetFirst;
        
    } else if (previousMessage && !nextMessage) {
        
        return FRDChatCellPositionInSetLast;
        
    } else {
        
        FRDChatMessage *currentMessage = self.messageHistory[indexPath.row];
        
        if (previousMessage.ownerType == currentMessage.ownerType && nextMessage.ownerType == currentMessage.ownerType) {
            
            return FRDChatCellPositionInSetIntermediary;
            
        } else if (previousMessage.ownerType == currentMessage.ownerType) {
            
            return FRDChatCellPositionInSetLast;
            
        } else if (nextMessage.ownerType == currentMessage.ownerType) {
            
            return FRDChatCellPositionInSetFirst;
            
        } else {
            return FRDChatCellPositionInSetFirst;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
