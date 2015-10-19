//
//  UIView+Pulsing.m
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "UIView+Pulsing.h"

static CGFloat const kPulsingDuration = .6f;
static CGFloat const kFromPulsingValue = .8f;

static CGFloat const kScalingDuration = .25f;
static CGFloat const kFromScaleValue = 1.5f;

static CGFloat const kToValue = 1.f;

@implementation UIView (Pulsing)

- (CABasicAnimation *)pulsingAnimationFrom:(CGFloat)from to:(CGFloat)to withDuration:(CGFloat)duration
{
    CABasicAnimation *pulsingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulsingAnimation.duration = duration;
    pulsingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulsingAnimation.fromValue = @(from);
    pulsingAnimation.toValue = @(to);
    
    return pulsingAnimation;
}

- (void)highlightWithScaling
{
    [self.layer addAnimation:[self pulsingAnimationFrom:kFromScaleValue to:kToValue withDuration:kScalingDuration] forKey:@"pulsing"];
}

- (void)pulsingWithWavesInView:(UIView *)viewForWaves repeating:(BOOL)repeating
{
    UIColor *stroke = UIColorFromRGB(0x535487);
    UIColor *fill = UIColorFromRGB(0xEAFEFF);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:CGRectGetWidth(self.frame)/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CGPoint convertedCenter = [viewForWaves convertPoint:self.center fromView:viewForWaves];

    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = convertedCenter;
    circleShape.fillColor = fill.CGColor;
    circleShape.opacity = 0.f;
    
    CAShapeLayer *strokeLayer = [CAShapeLayer layer];
    strokeLayer.path = path.CGPath;
    strokeLayer.position = convertedCenter;
    strokeLayer.fillColor = [UIColor clearColor].CGColor;
    strokeLayer.opacity = 0;
    strokeLayer.strokeColor = stroke.CGColor;
    strokeLayer.lineWidth = 2.f;

    @autoreleasepool {
        for (CALayer *layer in viewForWaves.layer.sublayers) {
            if ([layer animationForKey:@"waves"] && repeating) {
                [layer removeAllAnimations];
            }
        }
    }
    
    [viewForWaves.layer insertSublayer:circleShape below:self.layer];
    [viewForWaves.layer insertSublayer:strokeLayer below:circleShape];
    
    [CATransaction begin];
    
    //Remove circleShape layer after completion
    [CATransaction setCompletionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [circleShape removeFromSuperlayer];
            [strokeLayer removeFromSuperlayer];
        });
    }];
    
    CABasicAnimation *scaleWavesAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleWavesAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleWavesAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(4.f, 4.f, 1.f)];
    
    CAKeyframeAnimation *alphaFillAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    alphaFillAnimation.values = @[@0.1f, @0];
    
    CABasicAnimation *alphaStrokeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaStrokeAnimation.fromValue = @1.f;
    alphaStrokeAnimation.toValue = @.01f;
    
    CABasicAnimation *pulsingAnimation = [self pulsingAnimationFrom:kFromPulsingValue to:kToValue withDuration:kPulsingDuration];
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleWavesAnimation, alphaFillAnimation, alphaStrokeAnimation];
    animation.duration = kPulsingDuration * 2.f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    if (repeating) {
        pulsingAnimation.repeatCount = HUGE_VAL;
        pulsingAnimation.autoreverses = YES;
        animation.repeatCount = HUGE_VAL;
    }
    
    [self.layer addAnimation:pulsingAnimation forKey: repeating ? @"repeatingPulsing" : @"notRepeatingPulsing"];
    [circleShape addAnimation:animation forKey:@"waves"];
    [strokeLayer addAnimation:animation forKey:@"waves"];
    
    [CATransaction commit];
}

@end
