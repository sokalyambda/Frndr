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

#import "NMRangeSlider.h"

@interface FRDSearchSettingsController ()

@property (weak, nonatomic) IBOutlet UIView *dropDownHolderContainer;
@property (weak, nonatomic) IBOutlet UIView *relationshipsContainer;

@property (weak, nonatomic) IBOutlet NMRangeSlider *ageRangeSlider;

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
    [self configureAgeRangeSlider];
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

- (void)configureAgeRangeSlider
{
    UIImage* image;
    
    image = [UIImage imageNamed:@"Slider_Thumb"];
 //   image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    self.ageRangeSlider.trackBackgroundImage = image;
    
//    image = [UIImage imageNamed:@"Shape-9"];
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 7.0, 2.0, 7.0)];
//    self.ageRangeSlider.trackImage = image;
    
    image = [UIImage imageNamed:@"Slider_Thumb"];
    self.ageRangeSlider.lowerHandleImageNormal = image;
    self.ageRangeSlider.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"Slider_Thumb"];
    self.ageRangeSlider.lowerHandleImageHighlighted = image;
    self.ageRangeSlider.upperHandleImageHighlighted = image;
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
