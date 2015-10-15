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

#import "FRDChatManager.h"

#import "UIResponder+FirstResponder.h"

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

static NSString *const kReadEventName = @"read";
static NSString *const kUserId = @"userId";
static NSString *const kFriendId = @"friendId";

@interface FRDChatTableController ()

@property (strong, nonatomic) UILongPressGestureRecognizer *longPressRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation FRDChatTableController

@synthesize messageHistory = _messageHistory;

dispatch_queue_t messages_unpacking_queue() {
    
    static dispatch_queue_t matrix_calculations_queue;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        matrix_calculations_queue = dispatch_queue_create("messages_unpacking_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return matrix_calculations_queue;
}

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
    [self addGestureRecognizers];
    [self loadChatHistoryAndScrollToBottom:YES animated:NO];
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

/**
 *  Scroll to bottom
 */
- (void)scrollTableViewToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
    if (numberOfRows > 0) {
        NSIndexPath *lastRowIndexPath = [NSIndexPath indexPathForRow:numberOfRows - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastRowIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

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

- (void)addGestureRecognizers
{
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showClearMessageActionSheet:)];
    [self.tableView addGestureRecognizer:self.longPressRecognizer];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.tableView addGestureRecognizer:self.tapRecognizer];
}

/**
 *  Load chat history with current friend
 */
- (void)loadChatHistoryAndScrollToBottom:(BOOL)toBottom animated:(BOOL)animated
{
    WEAK_SELF;
    if (!self.refreshControl.isRefreshing) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [FRDChatMessagesService getChatHistoryWithFriend:self.currentFriend.userId andPage:self.currentPage onSuccess:^(NSArray *chatHistory) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [weakSelf.refreshControl endRefreshing];
        
        if (chatHistory.count) {
            weakSelf.currentPage++;
            //set messages array
            NSMutableArray *updatedMessages = [NSMutableArray arrayWithArray:chatHistory];
            [updatedMessages addObjectsFromArray:weakSelf.messageHistory];
            weakSelf.messageHistory = updatedMessages;
        }
        
        if (toBottom) {
            //to bottom
            [weakSelf scrollTableViewToBottomAnimated:NO];
        }
        
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf.parentViewController andCompletion:nil];
    }];
}

- (IBAction)loadMoreMessages:(id)sender
{
    [self loadChatHistoryAndScrollToBottom:NO animated:NO];
}

- (void)clearMessageWithIndexPath:(NSIndexPath *)indexPath
{
    FRDChatMessage *message = self.messageHistory[indexPath.row];
    
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FRDProjectFacade clearMessageWithId:message.messageId OnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [self.messageHistory removeObjectAtIndex:indexPath.row];
        //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf.parentViewController andCompletion:nil];
    }];
}

- (void)showClearMessageActionSheet:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pressLocation = [longPressRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pressLocation];
        
        UIAlertController *clearMessageController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Do you want to delete this message?") preferredStyle:UIAlertControllerStyleActionSheet];
        
        WEAK_SELF;
        UIAlertAction *deleteMessageAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Delete message") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [weakSelf clearMessageWithIndexPath:indexPath];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        
        [clearMessageController addAction:deleteMessageAction];
        [clearMessageController addAction:cancelAction];
        
        [self presentViewController:clearMessageController animated:YES completion:nil];
    }
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)tapRecognizer
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

- (void)subscribeForMessagesNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessageNotification:) name:DidReceiveNewMessageNotification object:nil];
}

- (void)unsibscribeFromMessagesNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    dispatch_async(messages_unpacking_queue(), ^{
        
        FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
        
        @synchronized(self) {
            //Message from socket has ownerId, friendId, messageBody;
            FRDChatMessage *message = (FRDChatMessage *)notification.object;
            
            //For messages unreading
            NSString *currentUserId = currentProfile.userId;
            NSString *friendId = self.currentFriend.userId;
            if (![currentUserId isEqualToString:message.ownerId]) {
                [[FRDChatManager sharedChatManager] emitEvent:kReadEventName withItems:@[@{kUserId: currentUserId,
                                                                                           kFriendId: friendId}]];
            }
            
            if ([currentProfile.userId isEqualToString:message.ownerId]) {
                
                message.ownerType = FRDMessageOwnerTypeUser;
                
            } else if ([self.currentFriend.userId isEqualToString:message.ownerId]) {
                
                message.ownerType = FRDMessageOwnerTypeFriend;
                
            }
            
            message.creationDate = [NSDate date];
            
            
            [self.messageHistory addObject:message];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self scrollTableViewToBottomAnimated:NO];
        });
        
    });
}

@end
