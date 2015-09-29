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
        [self configureSliders];
        [self getCurrentSearchSettings];
    });
}

#pragma mark - Accessors

- (void)setCurrentDistance:(long long)currentDistance
{
    _currentDistance = currentDistance;
    self.distanceLabel.text = [NSString stringWithFormat:@"%lld miles", (long long)currentDistance];
}

- (void)setCurrentMinimumAge:(NSInteger)currentMinimumAge
{
    _currentMinimumAge = currentMinimumAge;
    self.ageRangeLabel.text = [NSString stringWithFormat:@"%ld - %ld years", (long)currentMinimumAge, (long)self.currentMaximumAge];
}

- (void)setCurrentMaximumAge:(NSInteger)currentMaximumAge
{
    _currentMaximumAge = currentMaximumAge;
    self.ageRangeLabel.text = [NSString stringWithFormat:@"%ld - %ld years", (long)self.currentMinimumAge, (long)currentMaximumAge];
}

#pragma mark - Actions

/**
 *  Get search settings for current user
 */
- (void)getCurrentSearchSettings
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getCurrentSearchSettingsOnSuccess:^(FRDSearchSettings *currentSearchSettings) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        FRDCurrentUserProfile *profile = [FRDStorageManager sharedStorage].currentUserProfile;
        profile.currentSearchSettings = currentSearchSettings;
        [weakSelf updateSearchSettingsFields];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Update views relative to just obtained settings
 */
- (void)updateSearchSettingsFields
{
    FRDSearchSettings *currentSettings = [FRDStorageManager sharedStorage].currentUserProfile.currentSearchSettings;
    self.currentDistance = currentSettings.distance;
    //update relationship statuses
    
    //update drop down controller
    
    //update age range
    self.currentMinimumAge = currentSettings.minAgeValue;
    self.currentMaximumAge = currentSettings.maxAgeValue;
}

- (void)updateCurrentSearchSettings
{
    FRDSearchSettings *tempSearchSettings = [[FRDSearchSettings alloc] init];
    //set data to temp settings and update it
}

- (IBAction)saveSettingsClick:(id)sender
{
    
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
    self.relationshipController.sourceType = FRDRelationshipsDataSourceTypeSearchSettings;
}

- (void)configureSliders
{
    FRDRange range = { 1, 999 };
    self.distanceSlider.mode = FRDRangeSliderModeSingleThumb;
    self.distanceSlider.validRange = range;
    self.distanceSlider.maximumValue = 400;
    
    self.currentDistance = 400;
    
    range.location = 18;
    range.length = 32;
    self.ageRangeSlider.validRange = range;
    self.ageRangeSlider.minimumRange = 2;
    self.ageRangeSlider.minimumValue = 22;
    self.ageRangeSlider.maximumValue = 40;
    
    self.currentMinimumAge = 22;
    self.currentMaximumAge = 40;
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
