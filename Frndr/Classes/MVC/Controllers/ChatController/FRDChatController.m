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

#import "FRDBaseDropDownDataSource.h"

#import "FRDChatOption.h"
#import "FRDFriend.h"

#import "UIView+MakeFromXib.h"

#import "FRDProjectFacade.h"

#import "FRDChatMessagesService.h"

static NSString * const kChatTableControllerSegueIdentifier = @"chatTableControllerSegue";

static NSString * const kOptionsHiddenButtonImage = @"ChatOptionsUnactive";
static NSString * const kOptionsVisibleButtonImage = @"ChatOptionsActive";

@interface FRDChatController ()

@property (strong, nonatomic) UIBarButtonItem *showOptionsBarButton;
@property (strong, nonatomic) UIBarButtonItem *hideOptionsBarButton;

@property (strong, nonatomic) FRDDropDownTableView *dropDownOptionsList;

@property (weak, nonatomic) FRDChatTableController *chatTableController;

//@property (assign, nonatomic) NSInteger currenPage;

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
    
//    [self loadChatHistory];
}

#pragma mark - Actions

///**
// *  Load chat history with current friend
// */
//- (void)loadChatHistory
//{
//    WEAK_SELF;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [FRDChatMessagesService getChatHistoryWithFriend:self.currentFriend.userId andPage:1 onSuccess:^(NSArray *chatHistory) {
//        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        
//        //set messages array to child table view controller
//        weakSelf.chatTableController.messageHistory = [NSMutableArray arrayWithArray:chatHistory];
//    } onFailure:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
//    }];
//}

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
    
    [self.dropDownOptionsList dropDownTableBecomeActiveInView:self.view
                                               fromAnchorView:self.navigationController.navigationBar
                                               withDataSource:dataSource
                                        withShowingCompletion:^(FRDDropDownTableView *table) {

                                            self.navigationItem.rightBarButtonItem = table.isExpanded ? self.hideOptionsBarButton : self.showOptionsBarButton;
                                            
                                        } withCompletion:^(FRDDropDownTableView *table, id chosenValue) {
                                            if ([chosenValue isKindOfClass:[FRDChatOption class]]) {
                                                
                                                FRDChatOption *chosenOption = (FRDChatOption *)chosenValue;
                                                
                                                NSLog(@"Choosen option: %@", chosenOption.optionString);
                                                NSLog(@"Option selector: %@", NSStringFromSelector(chosenOption.optionSelector));
                                                
                                                if ([self respondsToSelector:chosenOption.optionSelector]) {
                                                    [self performSelector:chosenOption.optionSelector withObject:nil withObject:nil];
                                                }
                                            }
                                            [self fadeChatTableInOut];
                                        }];
}

#pragma mark - Options actions

- (void)viewProfileOptionClick
{
    
}

- (void)clearChatOptionClick
{
    
}

- (void)blockUserOptionClick
{
    
}

- (void)cancelOptionClick
{
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kChatTableControllerSegueIdentifier]) {
        self.chatTableController = segue.destinationViewController;
        self.chatTableController.currentFriend = self.currentFriend;
    }
}

@end
