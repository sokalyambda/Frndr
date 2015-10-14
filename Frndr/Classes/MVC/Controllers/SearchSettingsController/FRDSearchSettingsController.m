//
//  FRDSearchSettingsController.m
//  Frndr
//
//  Created by Pavlo on 9/14/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSearchSettingsController.h"
#import "FRDDropDownHolderController.h"
#import "FRDRelationshipStatusController.h"

#import "FRDDropDownTableView.h"

#import "UIView+MakeFromXib.h"
#import "UIImage+ColoredImage.h"

#import "FRDBaseDropDownDataSource.h"

#import "FRDSerialViewConstructor.h"

#import "FRDRangeSlider.h"

#import "FRDProjectFacade.h"

#import "FRDSearchSettings.h"

static CGFloat const kMinValidAge = 18.f;
static CGFloat const kMaxValidAge = 50.f;
static CGFloat const kYearsSpace = 2.f;
static CGFloat const kMaxDistanceValue = 5000.f;

@interface FRDSearchSettingsController ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageRangeLabel;

@property (weak, nonatomic) IBOutlet UIView *dropDownHolderContainer;
@property (weak, nonatomic) IBOutlet UIView *relationshipsContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet FRDRangeSlider *distanceSlider;
@property (weak, nonatomic) IBOutlet FRDRangeSlider *ageRangeSlider;

@property (nonatomic) FRDDropDownHolderController *dropDownHolderController;
@property (nonatomic) FRDRelationshipStatusController *relationshipController;

@property (nonatomic) NSRange ageValidRange;
@property (nonatomic) NSRange distanceValidRange;

@property (nonatomic) NSInteger currentMinimumAge;
@property (nonatomic) NSInteger currentMaximumAge;
@property (nonatomic) long long currentDistance;

@end

@implementation FRDSearchSettingsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDropDownHolderContainer];
    [self initRelationshipStatusesHolderContainer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configureDefaulSliders];
        [self performUpdatingActions];
    });
}

#pragma mark - Accessors

- (void)setCurrentDistance:(long long)currentDistance
{
    _currentDistance = currentDistance > kMaxDistanceValue ? kMaxDistanceValue : currentDistance;
    self.distanceLabel.text = [NSString stringWithFormat:@"%lld miles", (long long)_currentDistance];
}

- (void)setCurrentMinimumAge:(NSInteger)currentMinimumAge
{
    _currentMinimumAge = currentMinimumAge < kMinValidAge ? kMinValidAge : currentMinimumAge;
    self.ageRangeLabel.text = [NSString stringWithFormat:@"%ld - %ld years", (long)_currentMinimumAge, (long)self.currentMaximumAge];
}

- (void)setCurrentMaximumAge:(NSInteger)currentMaximumAge
{
    _currentMaximumAge = currentMaximumAge > kMaxValidAge ? kMaxValidAge : currentMaximumAge;
    self.ageRangeLabel.text = [NSString stringWithFormat:@"%ld - %ld years", (long)self.currentMinimumAge, (long)_currentMaximumAge];
}

#pragma mark - Actions

/**
 *  Perform needed update actios
 */
- (void)performUpdatingActions
{
    BOOL isSearchSettingsUpdateNeeded = [FRDStorageManager sharedStorage].isSearchSettingsUpdateNeeded;
    
    if (isSearchSettingsUpdateNeeded) {
        [self getCurrentSearchSettings];
    } else {
        [self updateSearchSettingsFields];
    }
}

/**
 *  Get search settings for current user
 */
- (void)getCurrentSearchSettings
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getCurrentSearchSettingsOnSuccess:^(FRDSearchSettings *currentSearchSettings) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [FRDStorageManager sharedStorage].searchSettingsUpdateNeeded = NO;
        
        [weakSelf updateSearchSettingsFields];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

- (void)configureDefaulSliders
{
    FRDRange distanceRange = { 1, kMaxDistanceValue - 1 };
    self.distanceSlider.mode = FRDRangeSliderModeSingleThumb;
    self.distanceSlider.validRange = distanceRange;
    self.distanceSlider.maximumValue = kMaxDistanceValue;
    
    self.currentDistance = self.distanceSlider.maximumValue;
    
    FRDRange ageRange = { kMinValidAge, kMaxValidAge - kMinValidAge };
    self.ageRangeSlider.validRange = ageRange;
    self.ageRangeSlider.minimumRange = kYearsSpace;
    self.ageRangeSlider.minimumValue = kMinValidAge;
    self.ageRangeSlider.maximumValue = kMaxValidAge;
    
    self.currentMinimumAge = self.ageRangeSlider.minimumValue;
    self.currentMaximumAge = self.ageRangeSlider.maximumValue;
}

/**
 *  Update views relative to just obtained settings
 */
- (void)updateSearchSettingsFields
{
    FRDSearchSettings *currentSettings = [FRDStorageManager sharedStorage].currentUserProfile.currentSearchSettings;
    self.currentDistance = currentSettings.distance;
    self.distanceSlider.maximumValue = self.currentDistance;
    //update relationship statuses
    [self.relationshipController updateWithSourceType:FRDSourceTypeSearchSettings];
    //update drop down controller
    [self.dropDownHolderController updateWithSourceType:FRDSourceTypeSearchSettings];
    //update age range
    self.currentMinimumAge = currentSettings.minAgeValue;
    self.currentMaximumAge = currentSettings.maxAgeValue;
    self.ageRangeSlider.minimumValue = self.currentMinimumAge;
    self.ageRangeSlider.maximumValue = self.currentMaximumAge;
}

/**
 *  Update search settings for current user
 */
- (void)updateCurrentSearchSettings
{
    FRDSearchSettings *tempSearchSettings = [[FRDSearchSettings alloc] init];
    tempSearchSettings.minAgeValue = self.currentMinimumAge;
    tempSearchSettings.maxAgeValue = self.currentMaximumAge;
    tempSearchSettings.sexualOrientation = self.dropDownHolderController.chosenOrientation;
    tempSearchSettings.smoker = self.dropDownHolderController.smoker;
    tempSearchSettings.relationshipStatuses = self.relationshipController.relationshipStatusesForSearch;
    tempSearchSettings.distance = self.currentDistance;
    //set data to temp settings and update it
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade updateCurrentSearchSettings:tempSearchSettings onSuccess:^(BOOL success) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [FRDStorageManager sharedStorage].searchSettingsUpdateNeeded = YES;
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

- (IBAction)saveSettingsClick:(id)sender
{
    [self updateCurrentSearchSettings];
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

- (void)initRelationshipStatusesHolderContainer
{
    self.relationshipController = [[FRDRelationshipStatusController alloc] initWithNibName:NSStringFromClass([FRDRelationshipStatusController class]) bundle:nil];
    [self.relationshipController.view setFrame:self.relationshipsContainer.frame];
    [self.relationshipsContainer addSubview:self.relationshipController.view];
    [self addChildViewController:self.relationshipController];
    [self.relationshipController didMoveToParentViewController:self];
    self.relationshipController.currentSourceType = FRDSourceTypeSearchSettings;
}

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationTitleView.titleText = LOCALIZED(@"Search Settings");
    
    UIBarButtonItem *rightIcon = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:nil];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = rightIcon;
}

#pragma mark - Event listeners

- (IBAction)distanceSliderValueChanged:(id)sender
{
    self.currentDistance = self.distanceSlider.maximumValue;
}

- (IBAction)ageRangeSliderValueChanged:(id)sender
{
    self.currentMinimumAge = self.ageRangeSlider.minimumValue;
    self.currentMaximumAge = self.ageRangeSlider.maximumValue;
}

@end
