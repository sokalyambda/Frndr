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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configureSliders];
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

- (void)configureSliders
{
    UIImage *outOfRangeImage = [UIImage imageWithColor:[UIColor colorWithRed:215.f / 255.f
                                                                       green:1.0
                                                                        blue:249.f / 255.f
                                                                       alpha:1.0]
                                               andSize:CGSizeMake(1, 1)];
    
    UIImage *inRangeImage = [UIImage imageWithColor:[UIColor colorWithRed:53.f / 255.f
                                                                       green:192.f / 255.f
                                                                        blue:186.f / 255.f
                                                                       alpha:1.0]
                                               andSize:CGSizeMake(1, 1)];
    
    UIImage *thumbImage = [UIImage imageNamed:@"Slider_Thumb"];
    
    [self.ageRangeSlider setThumbImage:thumbImage];
    [self.ageRangeSlider setTrackImage:outOfRangeImage];
    [self.ageRangeSlider setInRangeTrackImage:inRangeImage];
    
    self.ageRangeSlider.tracksHeight = 3.0;
    self.ageRangeSlider.mode = FRDRangeSliderModeRange;
    
    [self.distanceSlider setThumbImage:thumbImage];
    [self.distanceSlider setTrackImage:outOfRangeImage];
    [self.distanceSlider setInRangeTrackImage:inRangeImage];
    
    self.distanceSlider.tracksHeight = 3.0;
    self.distanceSlider.mode = FRDRangeSliderModeSingleThumb;
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
