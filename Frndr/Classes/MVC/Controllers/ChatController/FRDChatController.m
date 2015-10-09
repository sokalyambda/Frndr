//
//  FRDChatController.m
//  Frndr
//
//  Created by Pavlo on 10/5/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatController.h"
#import "FRDChatTableController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDDropDownTableView.h"
#import "FRDExpandableToThresholdTextView.h"

#import "FRDBaseDropDownDataSource.h"

#import "FRDChatOption.h"
#import "FRDFriend.h"

#import "UIView+MakeFromXib.h"
#import "UIResponder+FirstResponder.h"
#import "UITextView+Placeholder.h"

#import "FRDChatMessagesService.h"

static NSString * const kChatTableControllerSegueIdentifier = @"chatTableControllerSegue";

static NSString * const kOptionsHiddenButtonImage = @"ChatOptionsUnactive";
static NSString * const kOptionsVisibleButtonImage = @"ChatOptionsActive";

static NSString * const kReplyTextViewPlaceholder = @"Send a reply...";

@interface FRDChatController () <UITextViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *showOptionsBarButton;
@property (strong, nonatomic) UIBarButtonItem *hideOptionsBarButton;

@property (strong, nonatomic) FRDDropDownTableView *dropDownOptionsList;

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

- (IBAction)sendReplyClick:(id)sender
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    WEAK_SELF;
    [FRDChatMessagesService sendMessage:self.replyTextView.text toFriendWithId:self.currentFriend.userId onSuccess:^(BOOL isSuccess) {
        NSLog(@"message has been sent");
        weakSelf.replyTextView.text = @"";
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        NSLog(@"!!!!!message hasn't been sent!!!!!");
    }];
    
    [self.replyTextView clearTextWithPlaceholder:kReplyTextViewPlaceholder];
}

- (void)initDropDownTable
{
    self.dropDownOptionsList = [FRDDropDownTableView makeFromXib];
    
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
    self.replyTextView.linesThreshold = 5;
    self.replyTextView.placeholder = kReplyTextViewPlaceholder;
}

- (void)fadeChatTableInOut
{
    [UIView animateWithDuration:self.dropDownOptionsList.slideAnimationDuration animations:^{
        self.chatTableController.tableView.alpha = self.dropDownOptionsList.isExpanded ? 1.f : .45f;
    }];
}

- (void)switchOptionsState
{
    FRDBaseDropDownDataSource *dataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeChatOptions];
    
    [self fadeChatTableInOut];
    
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
                                            
                                            [weakSelf fadeChatTableInOut];
                                            
                                        }];
}

#pragma mark - Options actions

- (void)viewProfileOptionClick
{
    NSLog(@"Show profile of %@", self.currentFriend.fullName);
}

- (void)clearChatOptionClick
{
    NSLog(@"Clear chat with %@", self.currentFriend.fullName);
}

- (void)blockUserOptionClick
{
    NSLog(@"BLOCK %@", self.currentFriend.fullName);
}

- (void)cancelOptionClick
{
    
}

#pragma mark - Keyboard notification handlers

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize kbSize = keyBoardFrame.size;
    
    self.bottomSpaceToContainer.constant = kbSize.height;
    [UIView animateWithDuration:.5f
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
    NSInteger numberOfRows = [self.chatTableController.tableView numberOfRowsInSection:0];
    if (numberOfRows) {
        NSIndexPath *lastRowIndexPath = [NSIndexPath indexPathForRow:numberOfRows - 1 inSection:0];
        [self.chatTableController.tableView scrollToRowAtIndexPath:lastRowIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.bottomSpaceToContainer.constant = 0;
    [UIView animateWithDuration:.5f
                     animations:^{
                         [self.view layoutIfNeeded];
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

@end
