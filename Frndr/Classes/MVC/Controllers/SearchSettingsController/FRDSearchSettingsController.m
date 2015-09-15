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

#import "FRDSerialViewConstructor.h"

@interface FRDSearchSettingsController ()

@property (weak, nonatomic) IBOutlet UILabel *smokerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualOrientationLabel;

@property (nonatomic) FRDDropDownTableView *dropDownList;

@end

@implementation FRDSearchSettingsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDropDownTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (IBAction)smokerClick:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    FRDBaseDropDownDataSource *smokerDataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeSmoker];
    WEAK_SELF;
    [self.dropDownList dropDownTableBecomeActiveInView:self.view fromAnchorView:tapView withDataSource:smokerDataSource withCompletion:^(FRDDropDownTableView *table, NSString *chosenValue) {
        NSLog(@"chosen value %@", chosenValue);
        weakSelf.smokerLabel.text = chosenValue;
    }];
}

- (IBAction)sexualOrientationClick:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    FRDBaseDropDownDataSource *smokerDataSource = [FRDBaseDropDownDataSource dataSourceWithType:FRDDataSourceTypeSexualOrientation];
    WEAK_SELF;
    [self.dropDownList dropDownTableBecomeActiveInView:self.view fromAnchorView:tapView withDataSource:smokerDataSource withCompletion:^(FRDDropDownTableView *table, NSString *chosenValue) {
        NSLog(@"chosen value %@", chosenValue);
        weakSelf.sexualOrientationLabel.text = chosenValue;
    }];
}

- (void)initDropDownTable
{
    self.dropDownList = [FRDDropDownTableView makeFromXib];
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

@end
