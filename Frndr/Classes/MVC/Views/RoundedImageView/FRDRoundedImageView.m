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

- (void)customize
{
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.f;
    self.layer.masksToBounds = YES;
}

@end
