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
        [self setupAgeSliderWithValidRange:NSMakeRange(18, 30) minimumRange:0 defaultMinimum:22 maximum:40];
    });
}

#pragma mark - Accessors

- (void)setCurrentDistance:(NSInteger)currentDistance
{
    if (currentDistance >= self.distanceValidRange.location &&
        currentDistance <= self.distanceValidRange.location + self.distanceValidRange.length) {
        _currentDistance = currentDistance;
        self.distanceLabel.text = [NSString stringWithFormat:@"%ld miles", currentDistance];
    }
}

- (void)setCurrentMinimumAge:(NSInteger)currentMinimumAge
{
    if (currentMinimumAge >= self.ageValidRange.location &&
        currentMinimumAge <= self.ageValidRange.location + self.ageValidRange.length) {
        _currentMinimumAge = currentMinimumAge;
        self.ageRangeLabel.text = [NSString stringWithFormat:@"%ld - %ld years", currentMinimumAge, self.currentMaximumAge];
    }
}

- (void)setCurrentMaximumAge:(NSInteger)currentMaximumAge
{
    if (currentMaximumAge >= self.ageValidRange.location &&
        currentMaximumAge <= self.ageValidRange.location + self.ageValidRange.length) {
        _currentMaximumAge = currentMaximumAge;
        self.ageRangeLabel.text = [NSString stringWithFormat:@"%ld - %ld years", self.currentMinimumAge, currentMaximumAge];
    }
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
    self.distanceSlider.tracksHeight = 5.0;
    self.distanceSlider.mode = FRDRangeSliderModeSingleThumb;
    [self.distanceSlider addTarget:self
                            action:@selector(distanceSliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.distanceValidRange = validRange;
    [self.distanceSlider updateWithMaximumValue:(CGFloat)value / validRange.length];
    self.currentDistance = value;
}

- (void)setupAgeSliderWithValidRange:(NSRange)validRange minimumRange:(NSInteger)minimumRange
                      defaultMinimum:(NSInteger)minimum maximum:(NSInteger)maximum
{
    NSAssert(minimum < maximum, @"Minimum must be less than maximum!");
    
    self.ageRangeSlider.tracksHeight = 5.0;
    self.ageRangeSlider.mode = FRDRangeSliderModeRange;
    self.ageRangeSlider.minimumRange = (CGFloat)minimumRange / validRange.length;
    [self.ageRangeSlider addTarget:self
                            action:@selector(ageRangeSliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.ageValidRange = validRange;
    [self.ageRangeSlider updateWithMinimumValue:((CGFloat)minimum - validRange.location) / validRange.length
                                andMaximumValue:((CGFloat)maximum - validRange.location) / validRange.length];
    self.currentMinimumAge = minimum;
    self.currentMaximumAge = maximum;
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
    NSInteger distance = self.distanceValidRange.location + (self.distanceValidRange.length * self.distanceSlider.maximumValue);
    self.currentDistance = distance;
}

- (void)ageRangeSliderValueChanged:(id)sender
{
    NSInteger leftValue = self.ageValidRange.location + (self.ageValidRange.length * self.ageRangeSlider.minimumValue);
    NSInteger rightValue = self.ageValidRange.location + (self.ageValidRange.length * self.ageRangeSlider.maximumValue);
    
    self.currentMinimumAge = leftValue;
    self.currentMaximumAge = rightValue;
}

@end
