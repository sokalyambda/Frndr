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
@property (readonly, nonatomic) CGFloat frameWidthMinusThumbsWidth;
@property (readonly, nonatomic) CGFloat frameWidthMinusOneThumbWidth;
@property (readonly, nonatomic) CGFloat minimumDistanceBetweenThumbs;

@end


@implementation FRDRangeSlider

#pragma mark - Accessors

- (CGFloat)frameWidthMinusThumbsWidth
{
    return CGRectGetWidth(self.frame) - CGRectGetWidth(self.leftThumb.frame) - CGRectGetWidth(self.rightThumb.frame);
}

- (CGFloat)frameWidthMinusOneThumbWidth
{
    return CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumb.frame);
}

- (CGFloat)minimumDistanceBetweenThumbs
{
    return self.frameWidthMinusThumbsWidth * self.minimumRange / self.validRange.length;;
}

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

- (void)setInRangeTrackImage:(UIImage *)inRangeTrackImage
{
    self.inRangeTrack.image = inRangeTrackImage;
}

- (void)setOutRangeTrackImage:(UIImage *)outRangeTrackImage
{
    self.outRangeTrack.image = outRangeTrackImage;
}

- (void)setMinimumValue:(CGFloat)newMin
{
    if (self.mode == FRDRangeSliderModeRange) {
        _minimumValue = newMin;
        
        CGFloat normalizedX = (newMin - self.validRange.location) / self.validRange.length * self.frameWidthMinusThumbsWidth;
        self.leftThumb.frame = CGRectMake(normalizedX,
                                          CGRectGetMinY(self.leftThumb.frame),
                                          CGRectGetWidth(self.leftThumb.frame),
                                          CGRectGetHeight(self.leftThumb.frame));
        [self updateInRangeTrack];
        [self calculateValues];
    }
}

- (void)setMaximumValue:(CGFloat)newMax
{
    CGFloat normalizedX;
    
    if (self.mode == FRDRangeSliderModeSingleThumb) {
        normalizedX = (newMax - self.validRange.location) / self.validRange.length * (CGRectGetWidth(self.frame) - CGRectGetMaxX(self.rightThumb.bounds));
    } else {
        normalizedX = (newMax - self.validRange.location) / self.validRange.length * self.frameWidthMinusThumbsWidth;
        normalizedX += CGRectGetMaxX(self.rightThumb.bounds);
    }
    
    self.rightThumb.frame = CGRectMake(normalizedX,
                                       CGRectGetMinY(self.rightThumb.frame),
                                       CGRectGetWidth(self.rightThumb.frame),
                                       CGRectGetHeight(self.rightThumb.frame));
    [self updateInRangeTrack];
    [self calculateValues];
}

- (void)setMinimumRange:(CGFloat)minimumRange
{
    _minimumRange = minimumRange;
}

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
    
    _minimumValue = 0.f;
    _maximumValue = 1.f;
    _minimumRange = 0.f;
    _validRange.location = 0.f;
    _validRange.length = 1.f;
    
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
    [self setOutRangeTrackImage:[UIImage imageWithColor:UIColorFromRGB(0xD7FFF9) andSize:CGSizeMake(1, 1)]];
    [self setInRangeTrackImage:[UIImage imageWithColor:UIColorFromRGB(0x35C0BA) andSize:CGSizeMake(1, 1)]];
    
    self.mode = FRDRangeSliderModeRange;
    
    self.tracksHeight = 5.0;
    
    self.isInitialized = YES;
}


#pragma mark - Actions

- (void)updateInRangeTrack
{
    self.inRangeTrack.frame = CGRectMake(CGRectGetMidX(self.leftThumb.frame),
                                         CGRectGetMidY(self.bounds) - self.tracksHeight / 2.0,
                                         CGRectGetMidX(self.rightThumb.frame) - CGRectGetMidX(self.leftThumb.frame),
                                         self.tracksHeight);
}

- (void)updateOutRangeTrack
{
    self.outRangeTrack.frame = CGRectMake(CGRectGetMidX(self.leftThumb.bounds),
                                          CGRectGetMidY(self.bounds) - self.tracksHeight / 2.0,
                                          CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumb.frame),
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
            divident = (CGRectGetMidX(self.rightThumb.frame) - CGRectGetMidX(self.rightThumb.bounds));
            denominator = CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumb.frame);
            break;
        }
            
        case FRDRangeSliderModeRange: {
            divident = (CGRectGetMinX(self.rightThumb.frame) - CGRectGetWidth(self.rightThumb.frame));
            denominator = self.frameWidthMinusThumbsWidth;
            break;
        }
    }
    
    _minimumValue = (CGRectGetMaxX(self.leftThumb.frame) - CGRectGetWidth(self.leftThumb.frame)) / denominator * self.validRange.length + self.validRange.location;
    _maximumValue = divident / denominator * self.validRange.length + self.validRange.location;
}

/**
 *  Update all necessary values and frames, then send actions to subscribers
 */
- (void)performUpdatesAndSendActions
{
    [self updateInRangeTrack];
    [self calculateValues];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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
    
    if ([self.trackedSlider isEqual:self.leftThumb]) {
        float newX = MAX(0, CGRectGetMinX(self.leftThumb.frame) + deltaX);
        
        CGRect minSliderNewRect = CGRectMake(newX,
                                             CGRectGetMinY(self.leftThumb.frame),
                                             CGRectGetWidth(self.leftThumb.frame),
                                             CGRectGetHeight(self.leftThumb.frame));
        
        if (newX + CGRectGetWidth(self.leftThumb.frame) + self.minimumDistanceBetweenThumbs <= CGRectGetMinX(self.rightThumb.frame)) {
            self.leftThumb.frame = minSliderNewRect;
            
        } else {
            // This thumb will 'stick' to right thumb
            self.leftThumb.frame = CGRectMake(CGRectGetMinX(self.rightThumb.frame) - CGRectGetWidth(self.leftThumb.frame) - self.minimumDistanceBetweenThumbs,
                                              CGRectGetMinY(self.leftThumb.frame),
                                              CGRectGetWidth(self.leftThumb.frame),
                                              CGRectGetHeight(self.leftThumb.frame));
        }
        
    } else if ([self.trackedSlider isEqual:self.rightThumb]) {
        float newX = MIN(CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumb.frame),
                         CGRectGetMinX(self.rightThumb.frame) + deltaX);
        
        newX = MAX(0, newX);
        
        CGRect maxSliderNewRect = CGRectMake(newX,
                                             CGRectGetMinY(self.rightThumb.frame),
                                             CGRectGetWidth(self.rightThumb.frame),
                                             CGRectGetHeight(self.rightThumb.frame));

        if (newX - self.minimumDistanceBetweenThumbs >= CGRectGetMaxX(self.leftThumb.frame) || self.mode == FRDRangeSliderModeSingleThumb) {
            self.rightThumb.frame = maxSliderNewRect;
        } else {
            // This thumb will 'stick' to left thumb
            self.rightThumb.frame = CGRectMake(CGRectGetMaxX(self.leftThumb.frame) + self.minimumDistanceBetweenThumbs,
                                               CGRectGetMinY(self.rightThumb.frame),
                                               CGRectGetWidth(self.rightThumb.frame),
                                               CGRectGetHeight(self.rightThumb.frame));
        }
    }

    [self performUpdatesAndSendActions];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.trackedSlider = nil;
}

@end
