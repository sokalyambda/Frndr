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
#import "FRDDropDownCell.h"
#import "FRDRelationshipCollectionCell.h"

#import "FRDSwitch.h"

#import "UIResponder+FirstResponder.h"

#import "UIView+MakeFromXib.h"

#import "FRDSerialViewConstructor.h"

#import "FRDProjectFacade.h"

static NSString *const kPersonalBioTableControllerSegueIdentifier = @"personalBioTableControllerSegue";

@interface FRDMyProfileController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) FRDPersonalBioTableController *personalBioTableController;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet FRDSwitch *visibleOnFrndrSwitch;

@property (weak, nonatomic) IBOutlet UIView *topViewContainer;
@property (weak, nonatomic) IBOutlet UIView *relationshipsContainer;
@property (weak, nonatomic) IBOutlet UIView *dropDownHolderContainer;
@property (weak, nonatomic) IBOutlet UITextField *jobTitleField;

@property (strong, nonatomic) FRDMyProfileTopView *topView;
@property (strong, nonatomic) FRDRelationshipStatusController *relationshipController;
@property (strong, nonatomic) FRDDropDownHolderController *dropDownHolderController;

@property (assign, nonatomic) CGFloat previousVerticalOffset;

@end

@implementation FRDMyProfileController

#pragma mark - View's Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTopViewHolderContainer];
    [self initRelationshipStatusesHolderContainer];
    [self initDropDownHolderContainer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performUpdatingActions];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.topView updateProfileTopView];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard:self];
    return YES;
}

#pragma mark - Actions

- (IBAction)dismissKeyboard:(id)sender
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

- (IBAction)updateProfileClick:(id)sender
{
    [self updateCurrentProfile];
}

/**
 *  Update current user profile
 */
- (void)updateCurrentProfile
{
    FRDCurrentUserProfile *profileForUpdating = [[FRDCurrentUserProfile alloc] init];
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    
    profileForUpdating.age = currentProfile.age;
    profileForUpdating.fullName = currentProfile.fullName;
    profileForUpdating.genderString = currentProfile.genderString;
    
    profileForUpdating.jobTitle = self.jobTitleField.text;
    profileForUpdating.smoker = self.dropDownHolderController.smoker;
    profileForUpdating.sexualOrientation = self.dropDownHolderController.chosenOrientation;
    
    profileForUpdating.relationshipStatus = self.relationshipController.currentRelationshipStatus;
    
    NSMutableArray *lovedThings = [@[] mutableCopy];
    for (UITextField *interestField in self.personalBioTableController.mostLovedThingsFields) {
        [lovedThings addObject:interestField.text];
    }
    
    profileForUpdating.biography = self.personalBioTableController.personalBioThingILoveTextView.text;
    
    profileForUpdating.thingsLovedMost = lovedThings;
    profileForUpdating.visible = self.visibleOnFrndrSwitch.isOn;
    
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade updatedProfile:profileForUpdating onSuccess:^(FRDCurrentUserProfile *confirmedProfile) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [currentProfile updateWithUserProfile:confirmedProfile];
        
        
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

- (void)performUpdatingActions
{
    BOOL isSearchSettingsUpdateNeeded = [FRDStorageManager sharedStorage].isUserProfileUpdateNeeded;
    
    if (isSearchSettingsUpdateNeeded) {
        [self getCurrentUserProfile];
    } else {
        [self setProfileInformationToFields];
    }
}

/**
 *  Get current user profile
 */
- (void)getCurrentUserProfile
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getCurrentUserProfileOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [FRDStorageManager sharedStorage].userProfileUpdateNeeded = NO;
        
        [weakSelf setProfileInformationToFields];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

/**
 *  Set profile information to fields
 */
- (void)setProfileInformationToFields
{
    FRDCurrentUserProfile *profile = [FRDStorageManager sharedStorage].currentUserProfile;
    [self.dropDownHolderController updateWithSourceType:FRDSourceTypeMyProfile];
    [self.personalBioTableController update];
    self.jobTitleField.text = profile.jobTitle;
    [self.visibleOnFrndrSwitch setOn:profile.isVisible animated:NO];
    
    [self.relationshipController updateWithSourceType:FRDSourceTypeMyProfile];
}

- (IBAction)managePhotosPress:(id)sender
{
    FRDPhotoGalleryController *photoGalleryController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDPhotoGalleryController class])];
    [self.navigationController pushViewController:photoGalleryController animated:YES];
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
    self.relationshipController.currentSourceType = FRDSourceTypeMyProfile;
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

#pragma mark - Keyboard notification handlers

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyBoardFrame = [self.view.window convertRect:keyBoardFrame toView:self.scrollView];
    
    CGSize kbSize = keyBoardFrame.size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    UIView *currentResponder = [UIResponder currentFirstResponder];
    
    CGRect responderFrame;
    
    if ([currentResponder isEqual:self.jobTitleField]) {
        responderFrame = self.jobTitleField.frame;
    } else {
        responderFrame = [currentResponder convertRect:currentResponder.frame toView:self.scrollView];
    }
    
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
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.previousVerticalOffset);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPersonalBioTableControllerSegueIdentifier]) {
        self.personalBioTableController = (FRDPersonalBioTableController *)[segue destinationViewController];
    }
}

#pragma mark - UIGestureRecognizerDelegate

/**
 *  Allow tapping on ralationship statuses and drop down elements
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view.superview isKindOfClass:[FRDDropDownCell class]] ||
        [touch.view isDescendantOfView:self.relationshipsContainer]) {
        return NO;
    }
    return YES;
}

@end
