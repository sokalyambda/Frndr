//
//  FRDSearchSettingsController.m
//  Frndr
//
//  Created by Pavlo on 9/14/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSearchSettingsController.h"

#import "FRDDropDownTableView.h"

#import "UIView+MakeFromXib.h"

#import "FRDBaseDropDownDataSource.h"

@interface FRDSearchSettingsController ()

@property (nonatomic) FRDDropDownTableView *dropDownList;

@end

@implementation FRDSearchSettingsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDropDownTable];
}

#pragma mark - Actions

- (IBAction)smokerClick:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    FRDBaseDropDownDataSource *smokerDataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeSmoker];
    [self.dropDownList dropDownTableBecomeActiveInView:self.view fromAnchorView:tapView withDataSource:smokerDataSource withCompletion:^(FRDDropDownTableView *table, NSString *chosenValue) {
        NSLog(@"chosen value %@", chosenValue);
    }];
}

- (IBAction)sexualOrientationClick:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    FRDBaseDropDownDataSource *smokerDataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeSexualOrientation];
    [self.dropDownList dropDownTableBecomeActiveInView:self.view fromAnchorView:tapView withDataSource:smokerDataSource withCompletion:^(FRDDropDownTableView *table, NSString *chosenValue) {
        NSLog(@"chosen value %@", chosenValue);
    }];
}

- (void)initDropDownTable
{
    self.dropDownList = [FRDDropDownTableView makeFromXib];
}

@end
