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

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageRangeLabel;

@property (weak, nonatomic) IBOutlet UIView *dropDownHolderContainer;
@property (weak, nonatomic) IBOutlet UIView *relationshipsContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet FRDRangeSlider *distanceSlider;
@property (weak, nonatomic) IBOutlet FRDRangeSlider *ageRangeSlider;

@property (nonatomic) FRDDropDownHolderController *dropDownHolderController;
@property (nonatomic) FRDRelationshipStatusController *relationshipController;

@property (nonatomic) NSRange ageValidRange;
@property (nonatomic) NSRange distanceValidRange;

@property (nonatomic) NSInteger currentMinimumAge;
@property (nonatomic) NSInteger currentMaximumAge;
@property (nonatomic) NSInteger currentDistance;

@end

@implementation FRDSearchSettingsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDropDownHolderContainer];
    [self initRelationshipStatusesHolderContainer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#warning Temporary magic numbers!
        [self setupDistanceSliderWithValidRange:NSMakeRange(1, 999) andDefaultValue:400];
        [self setupAgeSliderWithValidRange:NSMakeRange(16, 34) minimumRange:0 defaultMinimum:22 maximum:40];
    });
}

#pragma mark - Accessors

- (void)setCurrentDistance:(NSInteger)currentDistance
{
    _currentDistance = currentDistance;
    self.distanceLabel.text = [NSString stringWithFormat:@"%ld miles", currentDistance];
}

- (void)setCurrentMinimumAge:(NSInteger)currentMinimumAge
{
    _currentMinimumAge = currentMinimumAge;
    self.ageRangeLabel.text = [NSString stringWithFormat:@"%ld - %ld years", currentMinimumAge, self.currentMaximumAge];
}

- (void)setCurrentMaximumAge:(NSInteger)currentMaximumAge
{
    _currentMaximumAge = currentMaximumAge;
    self.ageRangeLabel.text = [NSString stringWithFormat:@"%ld - %ld years", self.currentMinimumAge, currentMaximumAge];
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

- (void)setupDistanceSliderWithValidRange:(NSRange)validRange andDefaultValue:(NSInteger)value
{
    [self.distanceSlider setupWithMode:FRDRangeSliderModeSingleThumb validRange:validRange minimumRange:0 startMinimumValue:0 startMaximumValue:value];
    self.distanceSlider.tracksHeight = 5.0;
    [self.distanceSlider addTarget:self
                            action:@selector(distanceSliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.currentDistance = self.distanceSlider.maximumValue;
}

- (void)setupAgeSliderWithValidRange:(NSRange)validRange minimumRange:(NSInteger)minimumRange
                      defaultMinimum:(NSInteger)minimum maximum:(NSInteger)maximum
{    
    [self.ageRangeSlider setupWithMode:FRDRangeSliderModeRange validRange:validRange minimumRange:minimumRange startMinimumValue:minimum startMaximumValue:maximum];
    self.ageRangeSlider.tracksHeight = 5.0;
    [self.ageRangeSlider addTarget:self
                            action:@selector(ageRangeSliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.currentMinimumAge = self.ageRangeSlider.minimumValue;
    self.currentMaximumAge = self.ageRangeSlider.maximumValue;
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

#pragma mark - Event listeners

- (void)distanceSliderValueChanged:(id)sender
{
    self.currentDistance = self.distanceSlider.maximumValue;
}

- (void)ageRangeSliderValueChanged:(id)sender
{
    self.currentMinimumAge = self.ageRangeSlider.minimumValue;
    self.currentMaximumAge = self.ageRangeSlider.maximumValue;
}

@end
