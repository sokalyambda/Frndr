//
//  UIView+Shaking.m
//  vdiabete
//
//  Created by Eugene Sokolenko on 22.04.15.
//  Copyright (c) 2015 kttsoft. All rights reserved.
//

#import "UIView+Shaking.h"

@implementation UIView (Shaking)

- (void)shakeView
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(self.center.x - 5,self.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(self.center.x + 5, self.center.y)]];
    [self.layer addAnimation:shake forKey:@"position"];
}

@end
