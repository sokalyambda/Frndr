//
//  UIView+Flashable.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

// red  0xf15364

#import "UIView+Flashable.h"

static CGFloat const kSingleAnimationDuration = .4f;
static CGFloat const kGroupAnimationDuration = 1.f;
static NSInteger const kAnimationRepeatCount = 2.f;

@implementation UIView (Flashable)

- (void)flashing
{
    UIColor *fromColor = UIColorFromRGB(0xf15364);
    UIColor *toColor = self.backgroundColor;
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = kSingleAnimationDuration;
    [colorAnimation setRepeatCount:kAnimationRepeatCount];
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    
    CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [flash setDuration:kSingleAnimationDuration];
    [flash setRepeatCount:kAnimationRepeatCount];
    [flash setFromValue:@(self.layer.opacity)];
    [flash setToValue:@0];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[colorAnimation, flash];
    animationGroup.duration = kGroupAnimationDuration;
    
    CALayer *roundedLayer = [CALayer layer];
    roundedLayer.frame = self.bounds;
    roundedLayer.cornerRadius = CGRectGetWidth(self.frame)/2.f;
    [self.layer addSublayer:roundedLayer];
    
    [roundedLayer addAnimation:animationGroup forKey:@"flashing"];
}

@end
