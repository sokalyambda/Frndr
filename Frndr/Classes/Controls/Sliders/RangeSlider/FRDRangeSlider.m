//
//  RangeSlider.m
//  RangeSlider
//
//  Created by Murray Hughes on 04/08/2012
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//

#import "FRDRangeSlider.h"

#import "UIImage+ColoredImage.h"

@interface FRDRangeSlider ()

@property (nonatomic) UIImageView *leftThumb;
@property (nonatomic) UIImageView *rightThumb;
@property (nonatomic) UIImageView *outRangeTrack;
@property (nonatomic) UIImageView *inRangeTrack;

@property (nonatomic) id trackedSlider;

@property (nonatomic) BOOL isInitialized;

@end


@implementation FRDRangeSlider

#pragma mark - Lifecycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self commonInit];
}

- (void)commonInit
{
    if (self.isInitialized) {
        return;
    }
    
    _minimumValue = 0.0;
    _maximumValue = 1.0;
    _minimumRange = 0.0;
    
    _outRangeTrack = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMidY(self.frame),
                                                                   CGRectGetWidth(self.frame),
                                                                   CGRectGetHeight(self.frame))];
    _outRangeTrack.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_outRangeTrack];
    
    _inRangeTrack = [[UIImageView alloc]
                     initWithFrame:CGRectMake(_minimumValue * CGRectGetWidth(self.frame),
                                              CGRectGetMidY(self.frame),
                                              (_maximumValue - _minimumValue) * CGRectGetWidth(self.frame),
                                              CGRectGetHeight(self.frame))];
    
    _inRangeTrack.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_inRangeTrack];
    
    _leftThumb = [[UIImageView alloc] initWithFrame:
                  CGRectMake(self.minimumValue * CGRectGetWidth(self.frame),
                             CGRectGetMidY(self.bounds) - CGRectGetHeight(self.frame) / 2.0,
                             CGRectGetHeight(self.frame),
                             CGRectGetHeight(self.frame))];
    _leftThumb.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_leftThumb];
    
    _rightThumb = [[UIImageView alloc] initWithFrame:
                   CGRectMake(self.maximumValue * CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame),
                              CGRectGetMidY(self.bounds) - CGRectGetHeight(self.frame) / 2.0,
                              CGRectGetHeight(self.frame),
                              CGRectGetHeight(self.frame))];
    _rightThumb.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_rightThumb];
    
    [self setThumbImage:[UIImage imageNamed:@"Slider_Thumb"]];
    [self setTrackImage:[UIImage imageWithColor:UIColorFromRGB(0xD7FFF9) andSize:CGSizeMake(1, 1)]];
    [self setInRangeTrackImage:[UIImage imageWithColor:UIColorFromRGB(0x35C0BA) andSize:CGSizeMake(1, 1)]];
    
    self.isInitialized = YES;
}

#pragma mark - Setters

- (void)setMode:(FRDRangeSliderMode)mode
{
    switch (mode) {
        case FRDRangeSliderModeSingleThumb: {
            self.minimumValue = 0.0;
            self.rightThumb.frame = self.leftThumb.frame;
            
            // Set left thumb's frame X pos to 0 so that InRangeTrack will be drawn from 0
            self.leftThumb.frame = CGRectMake(0,
                                              CGRectGetMinY(self.leftThumb.frame),
                                              CGRectGetWidth(self.leftThumb.frame),
                                              CGRectGetHeight(self.leftThumb.frame));
            
            [self.leftThumb removeFromSuperview];
            [self updateInRangeTrack];
            break;
        }
            
        case FRDRangeSliderModeRange: {
            [self addSubview:self.leftThumb];
            [self moveThumbsToDefaultPositions];
            [self updateInRangeTrack];
        }
    }
    
    _mode = mode;
}

- (void)setTracksHeight:(CGFloat)trackHeight
{
    _tracksHeight = trackHeight;
    
    self.outRangeTrack.frame = CGRectMake(CGRectGetMinX(self.bounds),
                                          CGRectGetMidY(self.bounds) - self.tracksHeight / 2.0,
                                          CGRectGetWidth(self.frame),
                                          trackHeight);
    
    [self updateInRangeTrack];
    [self updateOutRangeTrack];
}

- (void)setThumbImage:(UIImage *)image
{
    CGRect newLeftThumbFrame = CGRectMake(self.minimumValue * CGRectGetWidth(self.frame),
                                CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                                image.size.width,
                                image.size.height);
    
    CGRect newRightThumbFrame = CGRectMake(self.maximumValue * CGRectGetWidth(self.frame) - image.size.width,
                                          CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                                          image.size.width,
                                          image.size.height);

    self.leftThumb.frame = newLeftThumbFrame;
    self.rightThumb.frame = newRightThumbFrame;
    
    self.leftThumb.backgroundColor = [UIColor clearColor];
    self.leftThumb.image = image;
    
    self.rightThumb.backgroundColor = [UIColor clearColor];
    self.rightThumb.image = image;
    
    [self updateInRangeTrack];
    [self updateOutRangeTrack];
}

- (void)setInRangeTrackImage:(UIImage *)image
{
    self.inRangeTrack.image = image;
}

- (void)setTrackImage:(UIImage *)image
{
    self.outRangeTrack.image = image;
}

- (void)setMinimumValue:(CGFloat)newMin
{
    _minimumValue = newMin;
    [self updateInRangeTrack];
}

- (void)setMaximumValue:(CGFloat)newMax
{
    _maximumValue = newMax;
    [self updateInRangeTrack];
}

- (void)setMinimumRange:(CGFloat)length
{
    _minimumRange = MIN(1.0, MAX(length, 0.0)); //length must be between 0 and 1
    [self updateInRangeTrack];
}

#pragma mark - Actions

- (void)updateWithMinimumValue:(CGFloat)minimum andMaximumValue:(CGFloat)maximum
{
    NSLog(@"Max: %f, Min: %f", maximum, minimum);
    minimum = MAX(0, minimum);
    minimum = MIN(minimum, maximum);
    
    maximum = MIN(maximum, 1.0);
    maximum = MAX(minimum, maximum);
    
    
    
    _minimumValue = minimum;
    _maximumValue = maximum;
    
    self.leftThumb.frame = CGRectMake(self.minimumValue * CGRectGetWidth(self.frame),
                                      CGRectGetMinY(self.leftThumb.frame),
                                      CGRectGetWidth(self.leftThumb.frame),
                                      CGRectGetHeight(self.leftThumb.frame));
    
    self.rightThumb.frame = CGRectMake(self.maximumValue * CGRectGetWidth(self.frame),
                                       CGRectGetMinY(self.rightThumb.frame),
                                       CGRectGetWidth(self.rightThumb.frame),
                                       CGRectGetHeight(self.rightThumb.frame));
    
    [self calculateValues];
    [self updateInRangeTrack];
}

- (void)updateWithMinimumValue:(CGFloat)minimum
{
    [self updateWithMinimumValue:minimum andMaximumValue:self.maximumValue];
}

- (void)updateWithMaximumValue:(CGFloat)maximum
{
    [self updateWithMinimumValue:self.minimumValue andMaximumValue:maximum];
}

- (void)updateInRangeTrack
{
    self.inRangeTrack.frame = CGRectMake(CGRectGetMidX(self.leftThumb.frame),
                                         CGRectGetMidY(self.bounds) - self.tracksHeight / 2.0,
                                         CGRectGetMidX(self.rightThumb.frame) - CGRectGetMidX(self.leftThumb.frame),
                                         self.tracksHeight);
}

- (void)updateOutRangeTrack
{
    self.outRangeTrack.frame = CGRectMake(CGRectGetMidX(self.leftThumb.frame),
                                          CGRectGetMidY(self.bounds) - self.tracksHeight / 2.0,
                                          CGRectGetMidX(self.rightThumb.frame) - CGRectGetMidX(self.leftThumb.frame),
                                          self.tracksHeight);
}

- (void)moveThumbsToDefaultPositions
{
    self.leftThumb.frame = CGRectMake(0,
                                      CGRectGetMinY(self.leftThumb.frame),
                                      CGRectGetWidth(self.leftThumb.frame),
                                      CGRectGetHeight(self.leftThumb.frame));
    
    self.rightThumb.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumb.frame),
                                      CGRectGetMinY(self.rightThumb.frame),
                                      CGRectGetWidth(self.rightThumb.frame),
                                      CGRectGetHeight(self.rightThumb.frame));
}

- (void)calculateValues
{
    CGFloat denominator;
    CGFloat divident;

    switch (self.mode) {
        case FRDRangeSliderModeSingleThumb: {
            divident = (CGRectGetMidX(self.rightThumb.frame) - CGRectGetWidth(self.rightThumb.frame) / 2.0);
            denominator = CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumb.frame);
            break;
        }
            
        case FRDRangeSliderModeRange: {
            divident = (CGRectGetMinX(self.rightThumb.frame) - CGRectGetWidth(self.rightThumb.frame));
            denominator = CGRectGetWidth(self.frame) - CGRectGetWidth(self.leftThumb.frame) - CGRectGetWidth(self.rightThumb.frame);
            break;
        }
    }
    
    if (self.trackedSlider == self.leftThumb) {
        self.minimumValue = (CGRectGetMaxX(self.leftThumb.frame) - CGRectGetWidth(self.leftThumb.frame)) / denominator;
    } else {
        self.maximumValue = divident / denominator;
    }
}

#pragma mark - Touch handling

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.leftThumb.frame, [touch locationInView:self]) && self.mode == FRDRangeSliderModeRange) {
        self.trackedSlider = self.leftThumb;
    } else if (CGRectContainsPoint(self.rightThumb.frame, [touch locationInView:self])) {
        self.trackedSlider = self.rightThumb;
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    float deltaX = [touch locationInView:self].x - [touch previousLocationInView:self].x;
    
    CGFloat minimumDistanceBetweenThumbs = CGRectGetWidth(self.frame) * self.minimumRange;
    
    if (self.trackedSlider == self.leftThumb) {
        float newX = MAX(0, CGRectGetMinX(self.leftThumb.frame) + deltaX);
        
        CGRect minSliderNewRect = CGRectMake(newX,
                                             CGRectGetMinY(self.leftThumb.frame),
                                             CGRectGetWidth(self.leftThumb.frame),
                                             CGRectGetHeight(self.leftThumb.frame));
        
        if (newX + CGRectGetWidth(self.leftThumb.frame) + minimumDistanceBetweenThumbs <= CGRectGetMinX(self.rightThumb.frame)) {
            self.leftThumb.frame = minSliderNewRect;
        } else {
            // This thumb will 'stick' to right thumb
            self.leftThumb.frame = CGRectMake(CGRectGetMinX(self.rightThumb.frame) - CGRectGetWidth(self.leftThumb.frame) - minimumDistanceBetweenThumbs,
                                              CGRectGetMinY(self.leftThumb.frame),
                                              CGRectGetWidth(self.leftThumb.frame),
                                              CGRectGetHeight(self.leftThumb.frame));
        }
        
    } else if (self.trackedSlider == self.rightThumb) {
        float newX = MIN(CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumb.frame),
                         CGRectGetMinX(self.rightThumb.frame) + deltaX);
        
        newX = MAX(0, newX);
        
        CGRect maxSliderNewRect = CGRectMake(newX,
                                             CGRectGetMinY(self.rightThumb.frame),
                                             CGRectGetWidth(self.rightThumb.frame),
                                             CGRectGetHeight(self.rightThumb.frame));

        if (newX - minimumDistanceBetweenThumbs > CGRectGetMaxX(self.leftThumb.frame) || self.mode == FRDRangeSliderModeSingleThumb) {
            self.rightThumb.frame = maxSliderNewRect;
        } else {
            // This thumb will 'stick' to left thumb
            self.rightThumb.frame = CGRectMake(CGRectGetMaxX(self.leftThumb.frame) + minimumDistanceBetweenThumbs,
                                               CGRectGetMinY(self.rightThumb.frame),
                                               CGRectGetWidth(self.rightThumb.frame),
                                               CGRectGetHeight(self.rightThumb.frame));
        }
    }
    
    [self updateInRangeTrack];
    [self calculateValues];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.trackedSlider = nil;
}

@end
