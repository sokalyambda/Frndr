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
    [self centerVertically];
}

- (void)insertText:(NSString *)text
{
    [super insertText:text];
    [self centerVertically];
}

- (void)deleteBackward
{
    [super deleteBackward];
    [self centerVertically];
}

- (void)centerVertically
{
    CGFloat textHeight = [self sizeThatFits:self.contentSize].height;
    CGFloat topInset = self.contentSize.height - textHeight;
    self.contentInset = UIEdgeInsetsMake(topInset / 2.0, 0, -topInset / 2.0, 0);
}

@end
