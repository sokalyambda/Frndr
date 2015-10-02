//
//  FRDDropDownHolderController.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDDropDownHolderController.h"

#import "FRDDropDownTableView.h"

#import "FRDBaseDropDownDataSource.h"

#import "UIView+MakeFromXib.h"

#import "FRDSexualOrientation.h"
#import "FRDSearchSettings.h"

#import "UIResponder+FirstResponder.h"

static NSString *const kDownArrow = @"downArrow";
static NSString *const kUpArrow = @"upArrow";

static NSString *const kSmokerString = @"SMOKER";
static NSString *const kNotSmokerString = @"NOT A SMOKER";

@interface FRDDropDownHolderController ()

@property (weak, nonatomic) IBOutlet UILabel *smokerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualOrientationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *smokerPointingArrow;
@property (weak, nonatomic) IBOutlet UIImageView *sexualOrientationPointingArrow;

@property (strong, nonatomic) FRDDropDownTableView *dropDownList;

@end

@implementation FRDDropDownHolderController

#pragma mark - Accessors

- (FRDSexualOrientation *)chosenOrientation
{
    if (!_chosenOrientation) {
        _chosenOrientation = [FRDSexualOrientation orientationWithOrientationString:LOCALIZED(@"ANY")];
    }
    return _chosenOrientation;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDropDownTable];
}

#pragma mark - Actions

- (void)initDropDownTable
{
    self.dropDownList = [FRDDropDownTableView makeFromXib];
}

- (IBAction)smokerClick:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    FRDBaseDropDownDataSource *smokerDataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeSmoker];
    WEAK_SELF;
    [self.dropDownList dropDownTableBecomeActiveInView:self.viewForDisplaying fromAnchorView:tapView withDataSource:smokerDataSource withShowingCompletion:^(FRDDropDownTableView *table) {
        
        table.arrowImageView = self.smokerPointingArrow;
        
    } withCompletion:^(FRDDropDownTableView *table, id chosenValue) {
        
        if ([chosenValue isKindOfClass:[NSString class]]) {
            weakSelf.smokerLabel.text = chosenValue;
            weakSelf.smoker = [chosenValue isEqualToString:kSmokerString] ? YES : NO;
        }
    }];
    
    // Dismiss keyboard if there is any on screen
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

- (IBAction)sexualOrientationClick:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    FRDBaseDropDownDataSource *sexualDataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeSexualOrientation];
    WEAK_SELF;

    [self.dropDownList dropDownTableBecomeActiveInView:self.viewForDisplaying fromAnchorView:tapView withDataSource:sexualDataSource withShowingCompletion:^(FRDDropDownTableView *table) {
        
        table.arrowImageView = self.sexualOrientationPointingArrow;
        
    } withCompletion:^(FRDDropDownTableView *table, id chosenValue) {
        
        if ([chosenValue isKindOfClass:[FRDSexualOrientation class]]) {
            FRDSexualOrientation *chosenOrientation = (FRDSexualOrientation *)chosenValue;
            weakSelf.sexualOrientationLabel.text = chosenOrientation.orientationString;
            weakSelf.chosenOrientation = chosenOrientation;
        }
    }];
    
    // Dismiss keyboard if there is any on screen
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

#pragma mark - Public Methods

- (void)updateWithSourceType:(FRDSourceType)sourceType
{
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    switch (sourceType) {
        case FRDSourceTypeMyProfile: {
            self.sexualOrientationLabel.text = currentProfile.sexualOrientation.orientationString.uppercaseString;
            self.smokerLabel.text = currentProfile.isSmoker ? kSmokerString : kNotSmokerString;
            break;
        }
        case FRDSourceTypeSearchSettings: {
            FRDSearchSettings *currentSearchSettings = currentProfile.currentSearchSettings;
            self.sexualOrientationLabel.text = currentSearchSettings.sexualOrientation.orientationString.uppercaseString;
            self.smokerLabel.text = currentSearchSettings.isSmoker ? kSmokerString : kNotSmokerString;
            break;
        }
            
        default:
            break;
    }
}

@end
