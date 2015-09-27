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
#import "FRDPhotoGalleryController.h"

#import "FRDMyProfileTopView.h"

#import "FRDSwitch.h"

#import "UIResponder+FirstResponder.h"

#import "UIView+MakeFromXib.h"

#import "FRDSerialViewConstructor.h"

static NSString * const kPersonalBioTableControllerSegueIdentifier = @"personalBioTableControllerSegue";

@interface FRDMyProfileController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) FRDPersonalBioTableController *personalBioTableController;

@property (weak, nonatomic) IBOutlet FRDSwitch *visibleOnFrndrSwitch;

@property (weak, nonatomic) IBOutlet UIView *topViewContainer;
@property (weak, nonatomic) IBOutlet UIView *relationshipsContainer;
@property (weak, nonatomic) IBOutlet UIView *dropDownHolderContainer;

@property (assign, nonatomic) CGFloat previousVerticalOffset;

@property (strong, nonatomic) FRDMyProfileTopView *topView;
@property (strong, nonatomic) FRDRelationshipStatusController *relationshipController;
@property (strong, nonatomic) FRDDropDownHolderController *dropDownHolderController;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation FRDMyProfileController

#pragma mark - View's Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTopViewHolderContainer];
    [self initRelationshipStatusesHolderContainer];
    [self initDropDownHolderContainer];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:self.tap];
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

#pragma mark - Actions

- (void)dismissKeyboard:(UIGestureRecognizer *)recognizer
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPersonalBioTableControllerSegueIdentifier]) {
        self.personalBioTableController = (FRDPersonalBioTableController *)[segue destinationViewController];
    }
}

- (IBAction)updateProfileClick:(id)sender
{
    
}

/**
 *  Set profile information to fields
 */
- (void)setProfileInformationToFields
{
    
}

/**
 *  Get profile information from fields
 */
- (void)getProfileInformationFromFields
{
    
}

- (IBAction)managePhotosPress:(id)sender
{
    FRDPhotoGalleryController *photoGalleryController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDPhotoGalleryController class])];
    [self.navigationController showViewController:photoGalleryController sender:self];
}

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationTitleView.titleText = LOCALIZED(@"My Profile");
    
    UIBarButtonItem *rightItem = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initTopViewHolderContainer
{
    self.topView = [FRDMyProfileTopView makeFromXib];
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

@end
