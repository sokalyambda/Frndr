//
//  FRDChatOptionsDropDownTableView.m
//  Frndr
//
//  Created by Eugenity on 12.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatOptionsDropDownTableView.h"

static NSString *const kAppearanceAnimation = @"appearanceAnimation";
static CGFloat const kMinAlphaValue = .0f;
static CGFloat const kMaxAlphaValue = .3f;

@interface FRDChatOptionsDropDownTableView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownHolderHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *fadeView;

@end

@implementation FRDChatOptionsDropDownTableView

- (void)showDropDownList
{
    [_presentedView addSubview:self];
    self.dropDownHolderHeightConstraint.constant = 0;
    [self layoutIfNeeded];
    
    //dd in moving now
    self.isMoving = YES;
    
    //dd will be presented
    if (_presentingCompletion) {
        self.isExpanded = YES;
        _presentingCompletion(self);
    }
    
    WEAK_SELF;
    [UIView animateWithDuration:self.slideAnimationDuration
                          delay:.1f
         usingSpringWithDamping:.6f
          initialSpringVelocity:.6f
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            CGRect newFrame = weakSelf.frame;
                            newFrame.origin.y += weakSelf.additionalOffset;
                            newFrame.size.height = CGRectGetHeight(_presentedView.frame);
                            weakSelf.frame = newFrame;
                            weakSelf.dropDownHolderHeightConstraint.constant = [weakSelf calculatedDropDownHeight];
                            [weakSelf layoutIfNeeded];
                            
                            [weakSelf.fadeView.layer addAnimation:[weakSelf fadeAppearanceAnimationInverse:NO] forKey:kAppearanceAnimation];
                            weakSelf.fadeView.alpha = 0.3f;
                        }
     
                     completion:^(BOOL finished) {
                         weakSelf.isMoving = NO;
                     }];
}

- (void)hideDropDownList
{
    [self layoutIfNeeded];
    
    //dd in moving now
    self.isMoving = YES;
    
    if (_presentingCompletion) {
        self.isExpanded = NO;
        _presentingCompletion(self);
    }
    
    WEAK_SELF;
    [UIView animateWithDuration:self.slideAnimationDuration
                          delay:0.1f
         usingSpringWithDamping:1.f
          initialSpringVelocity:1.f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            weakSelf.frame = savedDropDownTableFrame;
                            weakSelf.dropDownHolderHeightConstraint.constant = 0.f;
                            
                            [weakSelf.fadeView.layer addAnimation:[weakSelf fadeAppearanceAnimationInverse:YES] forKey:kAppearanceAnimation];
                            weakSelf.fadeView.alpha = 0.f;
                            
                            [weakSelf layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                         _anchorView = nil;
                         _dropDownDataSource = nil;
                         [weakSelf removeFromSuperview];
                         
                         weakSelf.isMoving = NO;
                     }];
}

- (CABasicAnimation *)fadeAppearanceAnimationInverse:(BOOL)inverse
{
    CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.fromValue = inverse ? @(kMaxAlphaValue) : @(kMinAlphaValue);
    alphaAnimation.toValue = inverse ? @(kMinAlphaValue) : @(kMaxAlphaValue);
    alphaAnimation.duration = .1f;
    return alphaAnimation;
}

@end
