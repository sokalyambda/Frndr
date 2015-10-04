//
//  FRDRoundedImageView.m
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRoundedImageView.h"

@implementation FRDRoundedImageView

#pragma mark - Accessors

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self customize];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self customize];
}

#pragma mark - Actions

- (void)customize
{
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.f;
    self.layer.masksToBounds = YES;
}

- (void)addBorder
{
    self.layer.borderColor = UIColorFromRGB(0x535487).CGColor;
    self.layer.borderWidth = 1.f;
}

@end
