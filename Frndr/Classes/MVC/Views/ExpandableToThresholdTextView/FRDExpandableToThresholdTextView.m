//
//  FRDExpandableToThresholdTextView.m
//  Frndr
//
//  Created by Pavlo on 10/8/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDExpandableToThresholdTextView.h"

@interface FRDExpandableToThresholdTextView ()

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation FRDExpandableToThresholdTextView

#pragma mark - Accessors

- (void)setMinimumHeight:(CGFloat)minimumHeight
{
    _minimumHeight = minimumHeight;
    self.heightConstraint.constant = minimumHeight;
}

- (NSLayoutConstraint *)heightConstraint
{
    if (!_heightConstraint) {
        _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:nil
                                                         attribute:0.f
                                                        multiplier:1.f
                                                          constant:0.f];
    }
    return _heightConstraint;
}

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForThresholdOvercoming) name:UITextViewTextDidChangeNotification object:nil];

    [self addConstraint:self.heightConstraint];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
