//
//  RangeSlider.р
//  RangeSlider
//
//  Created by Murray Hughes on 04/08/2012
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRDRangeSliderMode)
{
    FRDRangeSliderModeSingleThumb,
    FRDRangeSliderModeRange
};

typedef struct
{
    CGFloat location;
    CGFloat length;
} FRDRange;

@interface FRDRangeSlider : UIControl

@property (nonatomic) FRDRangeSliderMode mode;

/**
 *  Value of left thumb
 */
@property (readonly, nonatomic) CGFloat minimumValue;

/**
 *  Value of right thumb
 */
@property (readonly, nonatomic) CGFloat maximumValue;

/**
 *  Minimum distance between thumbs (should be between 0.0 and 1.0)
 */
@property (nonatomic) CGFloat minimumRange;

/**
 *  Height of 'in range' and 'out of range' tracks
 */
@property (nonatomic) CGFloat tracksHeight;


- (void)setThumbImage:(UIImage *)image;
- (void)setTrackImage:(UIImage *)image;
- (void)setInRangeTrackImage:(UIImage *)image;

- (void)setupWithMode:(FRDRangeSliderMode)mode
           validRange:(NSRange)validRange
         minimumRange:(NSInteger)minimumRange
    startMinimumValue:(NSInteger)startMinimum
    startMaximumValue:(NSInteger)startMaximum;

- (void)setupWithMode:(FRDRangeSliderMode)mode
           validRange:(FRDRange)validRange
         minimumRange:(CGFloat)minimumRange
                 step:(CGFloat)step
    startMinimumValue:(CGFloat)startMinimum
    startMaximumValue:(CGFloat)startMaximum;

@end
