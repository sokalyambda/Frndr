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

#import "FRDRangeSlider.h"

@interface FRDSearchSettingsController ()

@property (weak, nonatomic) IBOutlet UIView *dropDownHolderContainer;
@property (weak, nonatomic) IBOutlet UIView *relationshipsContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet FRDRangeSlider *distanceSlider;
@property (weak, nonatomic) IBOutlet FRDRangeSlider *ageRangeSlider;

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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configureDistanceSlider];
        [self configureAgeRangeSlider];
    });
}

#pragma mark - Actions

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
}

- (void)configureDistanceSlider
{
    [self.distanceSlider setThumbImage:[UIImage imageNamed:@"Slider_Thumb"]];
    [self.distanceSlider setTrackImage:[[UIImage imageNamed:@"SwitchBackground"]
                                        resizableImageWithCapInsets:UIEdgeInsetsMake(9.0, 35.0, 9.0, 35.0)]];
    [self.distanceSlider setInRangeTrackImage:[[UIImage imageNamed:@"downArrow"]
                                               resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)]];
    
    self.distanceSlider.tracksHeight = 3.0;
    self.distanceSlider.mode = FRDRangeSliderModeSingleThumb;
}

- (void)configureAgeRangeSlider
{
    [self.ageRangeSlider setThumbImage:[UIImage imageNamed:@"Slider_Thumb"]];
    [self.ageRangeSlider setTrackImage:[[UIImage imageNamed:@"SwitchBackground"]
                                        resizableImageWithCapInsets:UIEdgeInsetsMake(9.0, 35.0, 9.0, 35.0)]];
    [self.ageRangeSlider setInRangeTrackImage:[[UIImage imageNamed:@"downArrow"]
                                               resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)]];
    
    self.ageRangeSlider.tracksHeight = 3.0;
    self.ageRangeSlider.mode = FRDRangeSliderModeRange;
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
