//
//  FRDRoundedImageView.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRoundedView.h"

@implementation FRDRoundedView

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

- (void)customize
{
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.f;
    self.layer.masksToBounds = YES;
}

@end
