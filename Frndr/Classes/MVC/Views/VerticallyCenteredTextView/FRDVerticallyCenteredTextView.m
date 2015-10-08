//
//  FRDVerticallyCenteredTextView.m
//  Frndr
//
//  Created by Pavlo on 10/8/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDVerticallyCenteredTextView.h"

@implementation FRDVerticallyCenteredTextView

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];

    CGFloat textHeight = [self sizeThatFits:contentSize].height;
    CGFloat topInset = contentSize.height - textHeight;
    self.contentInset = UIEdgeInsetsMake(topInset / 2.0, 0, -topInset / 2.0, 0);
}

@end
