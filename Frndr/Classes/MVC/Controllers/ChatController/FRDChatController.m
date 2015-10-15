//
//  FRDChatController.m
//  Frndr
//
//  Created by Pavlo on 10/5/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatController.h"
#import "FRDChatTableController.h"
#import "FRDMyProfileController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDChatOptionsDropDownTableView.h"
#import "FRDExpandableToThresholdTextView.h"

#import "FRDBaseDropDownDataSource.h"

#import "FRDChatOption.h"
#import "FRDFriend.h"

#import "UIView+MakeFromXib.h"
#import "UIResponder+FirstResponder.h"

#import "FRDChatMessagesService.h"

static NSString *const kChatTableControllerSegueIdentifier = @"chatTableControllerSegue";

static NSString *const kOptionsHiddenButtonImage = @"ChatOptionsUnactive";
static NSString *const kOptionsVisibleButtonImage = @"ChatOptionsActive";

// Reply text view constants
static NSInteger const kReplyTextViewLinesThreshold = 4;
static CGFloat const kReplyTextViewMinimumHeight = 62.f;

@interface FRDChatController () <UITextViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *showOptionsBarButton;
@property (strong, nonatomic) UIBarButtonItem *hideOptionsBarButton;

@property (strong, nonatomic) FRDChatOptionsDropDownTableView *dropDownOptionsList;

@property (weak, nonatomic) FRDChatTableController *chatTableController;

@property (weak, nonatomic) IBOutlet FRDExpandableToThresholdTextView *replyTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceToContainer;

@end

@implementation FRDChatController

#pragma mark - Accessors

- (UIBarButtonItem *)showOptionsBarButton
{
    if (!_showOptionsBarButton) {
        _showOptionsBarButton = [FRDSerialViewConstructor customRightBarButtonForController:self
                                                                                   withAction:@selector(switchOptionsState)
                                                                                 andImageName:kOptionsHiddenButtonImage];
    }
    return _showOptionsBarButton;
}

- (UIBarButtonItem *)hideOptionsBarButton
{
    if (!_hideOptionsBarButton) {
        _hideOptionsBarButton = [FRDSerialViewConstructor customRightBarButtonForController:self
                                                                                   withAction:@selector(switchOptionsState)
                                                                                 andImageName:kOptionsVisibleButtonImage];
    }
    return _hideOptionsBarButton;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDropDownTable];
    [self configureReplyTextView];
}

#pragma mark - Actions

- (void)sendReply
{
    NSString *replyText = self.replyTextView.text;

    replyText = [replyText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (replyText.length) {
        
        WEAK_SELF;
        [FRDChatMessagesService sendMessage:replyText toFriendWithId:self.currentFriend.userId onSuccess:^(BOOL isSuccess) {

            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            
            [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        }];
    }
    
    self.replyTextView.text = @"";
}

- (IBAction)sendReplyClick:(id)sender
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    [self sendReply];
}

- (void)initDropDownTable
{
    self.dropDownOptionsList = [FRDChatOptionsDropDownTableView makeFromXib];
    
    self.dropDownOptionsList.alpha = 1.f;
    self.dropDownOptionsList.backgroundColor = [UIColor clearColor];
    self.dropDownOptionsList.cornerRadius = 0.f;
    self.dropDownOptionsList.additionalOffset = 0.f;
    self.dropDownOptionsList.isScrollEnabled = NO;
    self.dropDownOptionsList.areSeparatorsVisible = NO;
}

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = self.showOptionsBarButton;
}

- (void)configureReplyTextView
{
    self.replyTextView.linesThreshold = kReplyTextViewLinesThreshold;
    self.replyTextView.placeholder = LOCALIZED(@"Send a reply...");
    self.replyTextView.minimumHeight = kReplyTextViewMinimumHeight;
}

- (void)switchOptionsState
{
    if (self.dropDownOptionsList.isMoving) {
        return;
    }
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    FRDBaseDropDownDataSource *dataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeChatOptions];
    
    WEAK_SELF;
    [self.dropDownOptionsList dropDownTableBecomeActiveInView:self.view
                                               fromAnchorView:self.navigationController.navigationBar
                                               withDataSource:dataSource
                                        withShowingCompletion:^(FRDDropDownTableView *table) {
                                            
                                            weakSelf.navigationItem.rightBarButtonItem = table.isExpanded ? weakSelf.hideOptionsBarButton : weakSelf.showOptionsBarButton;
                                            
                                        } withCompletion:^(FRDDropDownTableView *table, id chosenValue) {
                                            if ([chosenValue isKindOfClass:[FRDChatOption class]]) {
                                                
                                                FRDChatOption *chosenOption = (FRDChatOption *)chosenValue;
                                                
                                                switch (chosenOption.currentType) {
                                                    case FRDChatOptionsTypeBlockUser: {
                                                        [weakSelf blockUserOptionClick];
                                                        break;
                                                    }
                                                    case FRDChatOptionsTypeClearChat: {
                                                        [weakSelf clearChatOptionClick];
                                                        break;
                                                    }
                                                    case FRDChatOptionsTypeViewProfile: {
                                                        [weakSelf viewProfileOptionClick];
                                                        break;
                                                    }
                                                        
                                                    default:
                                                        break;
                                                }
                                            }
                                        }];
}

/**
 *  Clear messages history with current friend
 */
- (void)clearMessagesHistoryWithCurrentFriend
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDChatMessagesService clearMessagesHistoryWithFriendWithId:self.currentFriend.userId onSuccess:^(BOOL isSuccess) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        weakSelf.chatTableController.messageHistory = [@[] mutableCopy];
        [weakSelf.chatTableController.tableView reloadData];
        
        [FRDAlertFacade showAlertWithMessage:LOCALIZED(@"Messages have been removed.") forController:weakSelf withCompletion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];

    }];
}

/**
 *  Block current friend by id
 */
- (void)blockCurrentFriend
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade blockFriendWithId:self.currentFriend.userId onSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [FRDAlertFacade showAlertWithMessage:LOCALIZED(@"User has been blocked.") forController:weakSelf withCompletion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Get full friend profile by id
 */
- (void)getFriendProfile
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getFriendProfileWithFriendId:self.currentFriend.userId onSuccess:^(FRDFriend *currentFriend) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        FRDMyProfileController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDMyProfileController class])];
        controller.currentFriend = currentFriend;
        [weakSelf.navigationController pushViewController:controller animated:YES];
        
        NSLog(@"current friend %@", currentFriend);
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

#pragma mark - Options actions

- (void)viewProfileOptionClick
{
    [self getFriendProfile];
}

- (void)clearChatOptionClick
{
    [self showClearChatActionSheet];
}

- (void)blockUserOptionClick
{
    [self showBlockFriendActionSheet];
}

- (void)cancelOptionClick
{
    //just cancel..
}

#pragma mark - Keyboard notification handlers

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize kbSize = keyBoardFrame.size;
    
    self.bottomSpaceToContainer.constant = kbSize.height;

    WEAK_SELF;
    [UIView animateWithDuration:.5f
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [weakSelf.chatTableController scrollTableViewToBottomAnimated:YES];
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.bottomSpaceToContainer.constant = 0;

    WEAK_SELF;
    [UIView animateWithDuration:.5f
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kChatTableControllerSegueIdentifier]) {
        self.chatTableController = (FRDChatTableController *)segue.destinationViewController;
        
        self.chatTableController.currentFriend = self.currentFriend;
        [self.chatTableController viewWillAppear:YES];
    }
}

#pragma mark - Alert Controllers

- (void)showClearChatActionSheet
{
    NSString *currentFriendName = self.currentFriend.fullName;
    
    UIAlertController *clearChatAlertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString localizedStringWithFormat:@"%@ %@?", LOCALIZED(@"Do you want to remove chat history with"), currentFriendName] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Clean") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self clearMessagesHistoryWithCurrentFriend];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleDefault handler:nil];
    
    [clearChatAlertController addAction:confirmAction];
    [clearChatAlertController addAction:cancelAction];
    
    [self presentViewController:clearChatAlertController animated:YES completion:nil];
}

- (void)showBlockFriendActionSheet
{
    NSString *currentFriendName = self.currentFriend.fullName;
    
    UIAlertController *blockFriendAlertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString localizedStringWithFormat:@"%@ %@?", LOCALIZED(@"Do you want to block"), currentFriendName] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Block") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self blockCurrentFriend];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleDefault handler:nil];
    
    [blockFriendAlertController addAction:confirmAction];
    [blockFriendAlertController addAction:cancelAction];
    
    [self presentViewController:blockFriendAlertController animated:YES completion:nil];
}

@end
