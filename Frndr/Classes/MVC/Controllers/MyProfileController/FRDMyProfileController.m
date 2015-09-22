//
//  FRDMyProfileController.m
//  Frndr
//
//  Created by Pavlo on 9/21/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMyProfileController.h"
#import "FRDRelationshipStatusController.h"
#import "FRDDropDownHolderController.h"
#import "FRDPersonalBioTableController.h"

#import "FRDMyProfileTopView.h"

#import "FRDSwitch.h"

#import "UIResponder+FirstResponder.h"

static NSString * const kPersonalBioTableControllerSegueIdentifier = @"personalBioTableControllerSegue";

@interface FRDMyProfileController ()

@property (assign, nonatomic) CGFloat previousVerticalOffset;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet FRDPersonalBioTableController *personalBioTableController;

@property (weak, nonatomic) IBOutlet FRDSwitch *visibleOnFrndrSwitch;

@property (weak, nonatomic) IBOutlet UIView *topViewContainer;
@property (weak, nonatomic) IBOutlet UIView *relationshipsContainer;
@property (weak, nonatomic) IBOutlet UIView *dropDownHolderContainer;

@property (strong, nonatomic) FRDMyProfileTopView *topView;
@property (strong, nonatomic) FRDRelationshipStatusController *relationshipController;
@property (strong, nonatomic) FRDDropDownHolderController *dropDownHolderController;

@end

@implementation FRDMyProfileController

#pragma mark - View's Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTopViewHolderContainer];
    [self initRelationshipStatusesHolderContainer];
    [self initDropDownHolderContainer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self subscribeForNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unsubscribeFromNotifications];
}

- (void)viewDidLayoutSubviews
{
    [self configureVisibleOnFrndrSwitch];
}

#pragma mark - Actions

- (void)initTopViewHolderContainer
{
    self.topView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FRDMyProfileTopView class]) owner:self options:nil].firstObject;
    self.topView.frame = self.topViewContainer.frame;
    [self.topViewContainer addSubview:self.topView];
}

- (void)initRelationshipStatusesHolderContainer
{
    self.relationshipController = [[FRDRelationshipStatusController alloc] initWithNibName:NSStringFromClass([FRDRelationshipStatusController class]) bundle:nil];
    [self.relationshipController.view setFrame:self.relationshipsContainer.frame];
    [self.relationshipsContainer addSubview:self.relationshipController.view];
    [self addChildViewController:self.relationshipController];
    [self.relationshipController didMoveToParentViewController:self];
}

- (void)initDropDownHolderContainer
{
    self.dropDownHolderController = [[FRDDropDownHolderController alloc] initWithNibName:NSStringFromClass([FRDDropDownHolderController class]) bundle:nil];
    self.dropDownHolderController.viewForDisplaying = self.scrollView;
    [self.dropDownHolderController.view setFrame:self.dropDownHolderContainer.frame];
    [self.dropDownHolderContainer addSubview:self.dropDownHolderController.view];
    [self addChildViewController:self.dropDownHolderController];
    [self.dropDownHolderController didMoveToParentViewController:self];
}

- (void)configureVisibleOnFrndrSwitch
{
    UIColor *labelsColor = [UIColor colorWithRed:53.f / 255.f
                                           green:184.f / 255.f
                                            blue:180.f / 255.f
                                           alpha:1.0];
    
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc]
                                        initWithFontAttributes:@{ UIFontDescriptorSizeAttribute : @16,
                                                                  UIFontDescriptorNameAttribute : @"Gill Sans" }];
    
    [self.visibleOnFrndrSwitch setOnImage:[UIImage imageNamed:@"SwitchBackground"]];
    [self.visibleOnFrndrSwitch setOffImage:[UIImage imageNamed:@"SwitchBackground"]];
    [self.visibleOnFrndrSwitch setSwitchImage:[UIImage imageNamed:@"Slider_Thumb"]];
    [self.visibleOnFrndrSwitch setOnText:@"YES"
           withFontDescriptor:fontDescriptor
                     andColor:labelsColor];
    
    [self.visibleOnFrndrSwitch setOffText:@"NO"
            withFontDescriptor:fontDescriptor
                      andColor:labelsColor];
    
    [self.visibleOnFrndrSwitch setOn:NO animated:NO];
}

- (void)subscribeForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notificaion handlers

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGSize kbSize = keyBoardFrame.size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    UIView *currentResponder = [UIResponder currentFirstResponder];
    
    // Get cell that contains current responder (a text field or a text view)
    UITableViewCell *responderContainingCell = (UITableViewCell *)currentResponder.superview.superview;
    
    // Convert responder's frame to top view coordinate system
    CGRect responderFrame = [self.personalBioTableController.tableView
                 convertRect:responderContainingCell.frame
                 toView:self.personalBioTableController.tableView.superview];
    responderFrame = [self.personalBioTableController.tableView.superview
                 convertRect:responderFrame
                 toView:self.view];
    
    self.previousVerticalOffset = self.scrollView.contentOffset.y;
    
    // Calculate necessary content offset
    CGFloat intersection = CGRectGetMaxY(responderFrame) - CGRectGetMinY(keyBoardFrame);
    if (intersection > 0) {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y + intersection);
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x,
                                                self.previousVerticalOffset);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPersonalBioTableControllerSegueIdentifier]) {
        self.personalBioTableController = [segue destinationViewController];
    }
}

@end
