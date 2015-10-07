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

#import "UIView+MakeFromXib.h"

static NSString * const kChatTableControllerSegueIdentifier = @"chatTableControllerSegue";

static NSString * const kOptionsHiddenButtonImage = @"ChatOptionsUnactive";
static NSString * const kOptionsVisibleButtonImage = @"ChatOptionsActive";

@interface FRDChatController ()

@property (strong, nonatomic) UIBarButtonItem *showOptionsBarButton;
@property (strong, nonatomic) UIBarButtonItem *hideOptionsBarButton;

@property (strong, nonatomic) FRDDropDownTableView *dropDownOptionsList;

@property (strong, nonatomic) FRDChatTableController *chatTableController;

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

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDropDownTable];
}

#pragma mark - Actions

- (void)initDropDownTable
{
    self.dropDownOptionsList = [FRDDropDownTableView makeFromXib];
    
    self.dropDownOptionsList.alpha = 1.0;
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

- (void)fadeChatTableIn
{
    [UIView animateWithDuration:self.dropDownOptionsList.slideAnimationDuration animations:^{
        self.chatTableController.tableView.alpha = 0.45;
    }];
}

- (void)fadeChatTableOut
{
    [UIView animateWithDuration:self.dropDownOptionsList.slideAnimationDuration animations:^{
        self.chatTableController.tableView.alpha = 1.0;
    }];
}

- (void)switchOptionsState
{
    FRDBaseDropDownDataSource *dataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeChatOptions];
    
    if (self.dropDownOptionsList.isExpanded) {
        [self fadeChatTableOut];
    } else {
        [self fadeChatTableIn];
    }
    
    [self.dropDownOptionsList dropDownTableBecomeActiveInView:self.view
                                               fromAnchorView:self.navigationController.navigationBar
                                               withDataSource:dataSource
                                        withShowingCompletion:^(FRDDropDownTableView *table) {
                                            if (table.isExpanded) {
                                                self.navigationItem.rightBarButtonItem = self.hideOptionsBarButton;
                                            } else {
                                                self.navigationItem.rightBarButtonItem = self.showOptionsBarButton;
                                            }
                                        } withCompletion:^(FRDDropDownTableView *table, id chosenValue) {
                                            if ([chosenValue isKindOfClass:[FRDChatOption class]]) {
                                                FRDChatOption *chosenOption = (FRDChatOption *)chosenValue;
                                                NSLog(@"Choosen option: %@", chosenOption.optionString);
                                                NSLog(@"Option selector: %@", NSStringFromSelector(chosenOption.optionSelector));
                                                
                                                if ([self respondsToSelector:chosenOption.optionSelector]) {
                                                    [self performSelector:chosenOption.optionSelector withObject:nil withObject:nil];
                                                }
                                            }
                                            [self fadeChatTableOut];
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
    }
}

@end
