//
//  FRDAnimator.m
//  Frndr
//
//  Created by Eugenity on 21.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDAnimator.h"

#import "FRDBaseContentController.h"

@implementation FRDAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5f;
}

static CGFloat const kChildViewPadding = 16.f;
static CGFloat const kDamping = 0.7f;
static CGFloat const kInitialSpringVelocity = 0.5f;
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    FRDBaseContentController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    FRDBaseContentController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // When sliding the views horizontally in and out, figure out whether we are going left or right.
    BOOL goingRight = ([transitionContext initialFrameForViewController:toViewController].origin.x < [transitionContext finalFrameForViewController:toViewController].origin.x);
    CGFloat travelDistance = [transitionContext containerView].bounds.size.width + kChildViewPadding;
    CGAffineTransform travel = CGAffineTransformMakeTranslation (goingRight ? travelDistance : -travelDistance, 0);
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformInvert (travel);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:!toViewController.transitionWithDamping ? 1.f : kDamping initialSpringVelocity:kInitialSpringVelocity options:0x00 animations:^{
        fromViewController.view.transform = travel;
        fromViewController.view.alpha = 0;
        toViewController.view.transform = CGAffineTransformIdentity;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
