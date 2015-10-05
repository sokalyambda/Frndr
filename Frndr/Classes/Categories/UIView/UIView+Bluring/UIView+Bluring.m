//
//  UIView+Bluring.m
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "UIView+Bluring.h"

@implementation UIView (Bluring)

- (void)blurView
{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        
        @autoreleasepool {
            for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[UIVisualEffectView class]]) {
                    return;
                }
            }
        }
        
        self.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:blurEffectView];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
