//
//  RangeSlider.m
//  RangeSlider
//
//  Created by Murray Hughes on 04/08/2012
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//

#import "FRDRangeSlider.h"

@interface FRDRangeSlider ()

@property (nonatomic) UIImageView *leftThumb;
@property (nonatomic) UIImageView *rightThumb;
@property (nonatomic) UIImageView *outRangeTrack;
@property (nonatomic) UIImageView *inRangeTrack;

@property (nonatomic) id trackedSlider;

@end


@implementation FRDRangeSlider

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
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
}


#pragma mark - Setters

- (void)setTracksHeight:(CGFloat)trackHeight
{
    _tracksHeight = trackHeight;
    
    self.outRangeTrack.frame = CGRectMake(CGRectGetMinX(self.bounds),
                                          CGRectGetMidY(self.bounds) - self.tracksHeight / 2.0,
                                          CGRectGetWidth(self.frame),
                                          trackHeight);
    
    [self updateInRangeTrack];
}

- (void)setMinThumbImage:(UIImage *)image
{
    CGRect newRect = CGRectMake(self.minimumValue * CGRectGetWidth(self.frame),
                                CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                                image.size.width,
                                image.size.height);
    
    if (!self.leftThumb) {
        self.leftThumb = [[UIImageView alloc] initWithFrame:newRect];
        self.leftThumb.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.leftThumb];
    } else {
        self.leftThumb.frame = newRect;
    }
    
    self.leftThumb.backgroundColor = [UIColor clearColor];
    self.leftThumb.image = image;
}

- (void)setMaxThumbImage:(UIImage *)image
{
    CGRect newRect = CGRectMake(self.maximumValue * (CGRectGetWidth(self.frame) - image.size.width),
                                CGRectGetMidY(self.bounds) - image.size.height / 2.0,
                                image.size.width,
                                image.size.height);
    
    if (!self.rightThumb) {
        self.rightThumb = [[UIImageView alloc] initWithFrame:newRect];
        self.rightThumb.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.rightThumb];
    } else {
        self.rightThumb.frame = newRect;
    }
    
    self.rightThumb.backgroundColor = [UIColor clearColor];
    self.rightThumb.image = image;
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

- (void)updateInRangeTrack
{
    self.inRangeTrack.frame = CGRectMake(CGRectGetMinX(self.leftThumb.frame) + CGRectGetWidth(self.leftThumb.frame) / 2.0,
                                         CGRectGetMidY(self.bounds) - self.tracksHeight / 2.0,
                                         CGRectGetMinX(self.rightThumb.frame) - CGRectGetMinX(self.leftThumb.frame),
                                         self.tracksHeight);
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    if (CGRectContainsPoint(self.leftThumb.frame, [touch locationInView:self])) {
        self.trackedSlider = self.leftThumb;
    } else if (CGRectContainsPoint(self.rightThumb.frame, [touch locationInView:self])) {
        self.trackedSlider = self.rightThumb;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    float deltaX = [touch locationInView:self].x - [touch previousLocationInView:self].x;
    
    CGFloat minimumDistanceBetweenThumbs = CGRectGetWidth(self.frame) * self.minimumRange;
    CGFloat currentDistanceBetweenThumbs = CGRectGetMinX(self.rightThumb.frame) - CGRectGetMaxX(self.leftThumb.frame);
    
    if (self.trackedSlider == self.leftThumb) {
        
        // Check for minimum distance between thumbs
        if (currentDistanceBetweenThumbs <= minimumDistanceBetweenThumbs && deltaX > 0) {
            return;
        }
        
        float newX = MAX(0, CGRectGetMinX(self.leftThumb.frame) + deltaX);
        
        CGRect minSliderNewRect = CGRectMake(newX,
                                             CGRectGetMinY(self.leftThumb.frame),
                                             CGRectGetWidth(self.leftThumb.frame),
                                             CGRectGetHeight(self.leftThumb.frame));
        
        if (!CGRectIntersectsRect(minSliderNewRect, self.rightThumb.frame)) {
            self.leftThumb.frame = minSliderNewRect;
        }
        
    } else if (self.trackedSlider == self.rightThumb) {
        
        // Check for minimum distance between thumbs
        if (currentDistanceBetweenThumbs <= minimumDistanceBetweenThumbs && deltaX < 0) {
            return;
        }
        
        float newX = MIN(CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumb.frame),
                         CGRectGetMinX(self.rightThumb.frame) + deltaX);
        
        CGRect maxSliderNewRect = CGRectMake(newX,
                                             CGRectGetMinY(self.rightThumb.frame),
                                             CGRectGetWidth(self.rightThumb.frame),
                                             CGRectGetHeight(self.rightThumb.frame));
        
        if (!CGRectIntersectsRect(maxSliderNewRect, self.leftThumb.frame)) {
            self.rightThumb.frame = maxSliderNewRect;
        }
    }
    
    [self updateInRangeTrack];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGFloat denominator = CGRectGetWidth(self.frame) - CGRectGetWidth(self.leftThumb.frame) - CGRectGetWidth(self.rightThumb.frame);
    
    if (self.trackedSlider == self.leftThumb) {
        self.minimumValue = (CGRectGetMaxX(self.leftThumb.frame) - CGRectGetWidth(self.leftThumb.frame)) / denominator;
    } else {
        self.maximumValue = (CGRectGetMinX(self.rightThumb.frame) - CGRectGetWidth(self.rightThumb.frame)) / denominator;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    self.trackedSlider = nil;
}

@end
