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

static NSString * const kDownArrow = @"downArrow";
static NSString * const kUpArrow = @"upArrow";

@interface FRDDropDownHolderController ()

@property (weak, nonatomic) IBOutlet UILabel *smokerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualOrientationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *smokerPointingArrow;
@property (weak, nonatomic) IBOutlet UIImageView *sexualOrientationPointingArrow;

@property (strong, nonatomic) FRDDropDownTableView *dropDownList;

@property (assign, nonatomic) BOOL isSmokerExpanded;
@property (assign, nonatomic) BOOL isSexualOrientationExpanded;

@end

@implementation FRDDropDownHolderController

#pragma mark - Accessors

- (void)setIsSmokerExpanded:(BOOL)isSmokerExpanded
{
    _isSmokerExpanded = isSmokerExpanded;
    
    if (isSmokerExpanded) {
        self.smokerPointingArrow.image = [UIImage imageNamed:kUpArrow];
    } else {
        self.smokerPointingArrow.image = [UIImage imageNamed:kDownArrow];
    }
}

- (void)setIsSexualOrientationExpanded:(BOOL)isSexualOrientationExpanded
{
    _isSexualOrientationExpanded = isSexualOrientationExpanded;
    
    if (isSexualOrientationExpanded) {
        self.sexualOrientationPointingArrow.image = [UIImage imageNamed:kUpArrow];
    } else {
        self.sexualOrientationPointingArrow.image = [UIImage imageNamed:kDownArrow];
    }
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
    self.isSmokerExpanded = NO;
    self.isSexualOrientationExpanded = NO;
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
    
    self.isSmokerExpanded = !self.isSmokerExpanded;
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
    
    self.isSexualOrientationExpanded = !self.isSexualOrientationExpanded;
}

#pragma mark - Public Methods

- (void)update
{
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    self.sexualOrientationLabel.text = currentProfile.sexualOrientation.orientationString;
    self.smokerLabel.text = currentProfile.isSmoker ? @"SMOKER" : @"NOT A SMOKER";
}

@end
