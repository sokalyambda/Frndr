//
//  RangeSlider.р
//  RangeSlider
//
//  Created by Murray Hughes on 04/08/2012
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//

@interface FRDRangeSlider : UIControl

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

- (void)setMinThumbImage:(UIImage *)image;
- (void)setMaxThumbImage:(UIImage *)image;
- (void)setTrackImage:(UIImage *)image;
- (void)setInRangeTrackImage:(UIImage *)image;

@end
