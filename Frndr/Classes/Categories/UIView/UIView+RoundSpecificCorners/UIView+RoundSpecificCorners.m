//
//  UIView+RoundSpecificCorners.m
//  Frndr
//
//  Created by Eugenity on 12.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "UIView+RoundSpecificCorners.h"

@implementation UIView (RoundSpecificCorners)

- (void)roundCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:corners
                                           cornerRadii:CGSizeMake(5.f, 5.f)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
