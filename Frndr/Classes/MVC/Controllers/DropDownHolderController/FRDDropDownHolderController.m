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

static NSString * const kDownArrow = @"downArrow";
static NSString * const kUpArrow = @"upArrow";

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
    [self.dropDownList dropDownTableBecomeActiveInView:self.viewForDisplaying fromAnchorView:tapView withDataSource:smokerDataSource withCompletion:^(FRDDropDownTableView *table, id chosenValue) {
        if ([chosenValue isKindOfClass:[NSString class]]) {
            weakSelf.smokerLabel.text = chosenValue;
            weakSelf.smoker = [chosenValue isEqualToString:@"SMOKER"] ? YES : NO;
            
            [self rotateArrow:self.smokerPointingArrow];
        }
    }];
    
    // Dismiss keyboard if there is any on screen
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    [self rotateArrow:self.smokerPointingArrow];
    [self resetArrowTransform:self.sexualOrientationPointingArrow];
}

- (IBAction)sexualOrientationClick:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    FRDBaseDropDownDataSource *smokerDataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeSexualOrientation];
    WEAK_SELF;
    [self.dropDownList dropDownTableBecomeActiveInView:self.viewForDisplaying fromAnchorView:tapView withDataSource:smokerDataSource withCompletion:^(FRDDropDownTableView *table, id chosenValue) {
        if ([chosenValue isKindOfClass:[FRDSexualOrientation class]]) {
            FRDSexualOrientation *chosenOrientation = (FRDSexualOrientation *)chosenValue;
            weakSelf.sexualOrientationLabel.text = chosenOrientation.orientationString;
            weakSelf.chosenOrientation = chosenOrientation;
            
            [self rotateArrow:self.sexualOrientationPointingArrow];
        }
    }];
    
    // Dismiss keyboard if there is any on screen
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    [self rotateArrow:self.sexualOrientationPointingArrow];
    [self resetArrowTransform:self.smokerPointingArrow];
}

- (void)rotateArrow:(UIImageView *)arrow
{
    [UIView animateWithDuration:0.2 animations:^{
        arrow.transform = CGAffineTransformRotate(arrow.transform, M_PI);
    }];
}

- (void)resetArrowTransform:(UIImageView *)arrow
{
    [UIView animateWithDuration:0.2 animations:^{
        arrow.transform = CGAffineTransformMakeRotation(0);
    }];
}

#pragma mark - Public Methods

- (void)updateWithSourceType:(FRDSourceType)sourceType
{
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    switch (sourceType) {
        case FRDSourceTypeMyProfile: {
            self.sexualOrientationLabel.text = currentProfile.sexualOrientation.orientationString.uppercaseString;
            self.smokerLabel.text = currentProfile.isSmoker ? @"SMOKER" : @"NOT A SMOKER";
            break;
        }
        case FRDSourceTypeSearchSettings: {
            FRDSearchSettings *currentSearchSettings = currentProfile.currentSearchSettings;
            self.sexualOrientationLabel.text = currentSearchSettings.sexualOrientation.orientationString.uppercaseString;
            self.smokerLabel.text = currentSearchSettings.isSmoker ? @"SMOKER" : @"NOT A SMOKER";
            break;
        }
            
        default:
            break;
    }
}

@end
