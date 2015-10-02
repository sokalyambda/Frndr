//
//  UIView+Pulsing.m
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "UIView+Pulsing.h"

static CGFloat const kDuration = .6f;

static CGFloat const kFromPulsingValue = .8f;
static CGFloat const kToPulsingValue = 1.f;

@implementation UIView (Pulsing)

- (CABasicAnimation *)pulsingAnimation
{
    CABasicAnimation *pulsingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulsingAnimation.duration = kDuration;
    pulsingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulsingAnimation.fromValue = [NSNumber numberWithFloat:kFromPulsingValue];
    pulsingAnimation.toValue = [NSNumber numberWithFloat:kToPulsingValue];
    
    return pulsingAnimation;
}

- (void)pulsingWithWavesInView:(UIView *)viewForWaves repeating:(BOOL)repeating
{
    UIColor *stroke = UIColorFromRGB(0x35B8B4);
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    
    CGPoint shapePosition = [viewForWaves convertPoint:self.center fromView:viewForWaves];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0.f;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 2.f;

    @autoreleasepool {
        for (CALayer *layer in viewForWaves.layer.sublayers) {
            if ([layer animationForKey:@"waves"] && repeating) {
                [layer removeAllAnimations];
            }
        }
    }

    [viewForWaves.layer addSublayer:circleShape];
    
    [CATransaction begin];
    
    //Remove circleShape layer after completion
    [CATransaction setCompletionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [circleShape removeFromSuperlayer];
        });
    }];
    
    CABasicAnimation *scaleWavesAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleWavesAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleWavesAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(4.f, 4.f, 1.f)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1.f;
    alphaAnimation.toValue = @.01f;
    
    CABasicAnimation *pulsingAnimation = [self pulsingAnimation];
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleWavesAnimation, alphaAnimation];
    animation.duration = kDuration * 2.f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    if (repeating) {
        pulsingAnimation.repeatCount = HUGE_VAL;
        pulsingAnimation.autoreverses = YES;
        animation.repeatCount = HUGE_VAL;
    }
    
    [circleShape addAnimation:animation forKey:@"waves"];
    
    [self.layer addAnimation:pulsingAnimation forKey: repeating ? @"repeatingPulsing" : @"notRepeatingPulsing"];
    
    [CATransaction commit];
}

@end
