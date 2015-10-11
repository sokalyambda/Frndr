//
//  FRDOverlayVIew.m
//  Frndr
//
//  Created by Eugenity on 28.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDOverlayView.h"

@implementation FRDOverlayView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.25f;
    self.layer.shadowOffset = CGSizeMake(0, 2.5f);
    self.layer.shadowRadius = 10.f;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.cornerRadius = 10.f;
}

@end
