//
//  FRDExpandableToThresholdTextView.m
//  Frndr
//
//  Created by Pavlo on 10/8/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDExpandableToThresholdTextView.h"

@implementation FRDExpandableToThresholdTextView

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    [self checkForThresholdOvercoming];
}

- (void)checkForThresholdOvercoming
{
    // Enable/Disable scroll depending on number of text lines
    CGFloat textHeight = [self sizeThatFits:self.contentSize].height;
    NSInteger numberOfLines = (textHeight - self.textContainerInset.top - self.textContainerInset.bottom) / self.font.lineHeight;
    
    // - 1 because changes will take effect only on next call, so we need to turn on scroll 1 call early
    self.scrollEnabled = (numberOfLines > self.linesThreshold - 1) ? YES : NO;
}

@end
