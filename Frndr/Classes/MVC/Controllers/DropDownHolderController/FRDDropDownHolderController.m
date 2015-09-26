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

@interface FRDDropDownHolderController ()

@property (weak, nonatomic) IBOutlet UILabel *smokerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualOrientationLabel;

@property (nonatomic) FRDDropDownTableView *dropDownList;

@end

@implementation FRDDropDownHolderController

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
        }
    }];
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
        }
    }];
}

#pragma mark - Public Methods

- (void)update
{
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    self.sexualOrientationLabel.text = currentProfile.sexualOrientation.orientationString;
    self.smokerLabel.text = currentProfile.isSmoker ? @"SMOKER" : @"NOT A SMOKER";
}

@end
