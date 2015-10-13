//
//  FRDExpandableToThresholdTextView.m
//  Frndr
//
//  Created by Pavlo on 10/8/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDExpandableToThresholdTextView.h"

@interface FRDExpandableToThresholdTextView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation FRDExpandableToThresholdTextView

#pragma mark - Accessors

- (void)setMinimumHeight:(CGFloat)minimumHeight
{
    _minimumHeight = minimumHeight;
    self.heightConstraint.constant = minimumHeight;
}

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForThresholdOvercoming) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - Actions

- (void)checkForThresholdOvercoming
{
    // Enable/Disable scroll depending on number of text lines
    CGFloat textHeight = [self sizeThatFits:self.contentSize].height;
    NSInteger numberOfLines = (textHeight - self.textContainerInset.top - self.textContainerInset.bottom) / self.font.lineHeight;
    
    if (numberOfLines > self.linesThreshold && !self.scrollEnabled) {
        self.scrollEnabled = YES;
        self.heightConstraint.constant = self.contentSize.height;
    } else if (numberOfLines <= self.linesThreshold) {
        self.scrollEnabled = NO;
        self.heightConstraint.constant = MAX(textHeight, self.minimumHeight);
    }
}

@end
