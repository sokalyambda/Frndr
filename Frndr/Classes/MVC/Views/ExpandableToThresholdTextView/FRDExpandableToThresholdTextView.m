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
    
    // Enable/Disable scroll depending on number of text lines
    CGFloat textHeight = [self sizeThatFits:contentSize].height;
    NSInteger numberOfLines = (textHeight - self.textContainerInset.top - self.textContainerInset.bottom) / self.font.lineHeight;
    self.scrollEnabled = (numberOfLines > self.linesThreshold) ? YES : NO;
    
    NSLog(@"Integer lines: %ld, float lines: %f", numberOfLines, (textHeight - self.textContainerInset.top -
                                                                  self.textContainerInset.bottom) / self.font.lineHeight);
    
    
}

@end
