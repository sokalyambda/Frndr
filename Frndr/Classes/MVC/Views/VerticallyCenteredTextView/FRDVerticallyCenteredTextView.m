//
//  FRDVerticallyCenteredTextView.m
//  Frndr
//
//  Created by Pavlo on 10/8/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDVerticallyCenteredTextView.h"

@implementation FRDVerticallyCenteredTextView

#pragma mark - Accessors

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    [self centerVertically];
}

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centerVertically)
                                                 name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - Actions

- (void)centerVertically
{
    CGFloat textHeight = [self sizeThatFits:self.contentSize].height;
    CGFloat topInset = self.contentSize.height - textHeight;
    self.contentInset = UIEdgeInsetsMake(topInset / 2.f, 0, -topInset / 2.f, 0);
}

@end
