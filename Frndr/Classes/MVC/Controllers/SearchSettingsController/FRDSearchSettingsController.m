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

#import "FRDBaseDropDownDataSource.h"

#import "FRDSerialViewConstructor.h"

@interface FRDSearchSettingsController ()

@property (weak, nonatomic) IBOutlet UIView *dropDownHolderContainer;
@property (weak, nonatomic) IBOutlet UIView *relationshipsContainer;

@property (nonatomic) FRDDropDownHolderController *dropDownHolderController;
@property (nonatomic) FRDRelationshipStatusController *relationshipController;

@end

@implementation FRDSearchSettingsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDropDownHolderContainer];
    [self initRelationshipStatusesHolderContainer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (void)initDropDownHolderContainer
{
    self.dropDownHolderController = [[FRDDropDownHolderController alloc] initWithNibName:NSStringFromClass([FRDDropDownHolderController class]) bundle:nil];
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
