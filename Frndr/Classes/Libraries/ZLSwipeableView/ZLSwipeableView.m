//
//  ZLSwipeableView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "ZLSwipeableView.h"
#import "ZLPanGestureRecognizer.h"

#import "FRDFriendDragableView.h"
#import "FRDFriendDragableParentView.h"

#import "UIView+MakeFromXib.h"

const NSUInteger ZLPrefetchedViewsNumber = 3;

ZLSwipeableViewDirection ZLDirectionVectorToSwipeableViewDirection(CGVector directionVector) {
    ZLSwipeableViewDirection direction = ZLSwipeableViewDirectionNone;
    if (ABS(directionVector.dx) > ABS(directionVector.dy)) {
        if (directionVector.dx > 0) {
            direction = ZLSwipeableViewDirectionRight;
        } else {
            direction = ZLSwipeableViewDirectionLeft;
        }
    } else {
        if (directionVector.dy > 0) {
            direction = ZLSwipeableViewDirectionDown;
        } else {
            direction = ZLSwipeableViewDirectionUp;
        }
    }
    
    return direction;
}

static NSString *const kDiscardIconName = @"discardIcon";
static NSString *const kApplyIconName = @"applyIcon";

@interface ZLSwipeableView () <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>

// UIDynamicAnimators
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UISnapBehavior *swipeableViewSnapBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *swipeableViewAttachmentBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *anchorViewAttachmentBehavior;
// AnchorView
@property (strong, nonatomic) UIView *anchorContainerView;
@property (strong, nonatomic) UIView *anchorView;
@property (nonatomic) BOOL isAnchorViewVisible;
// ContainerView
@property (strong, nonatomic) UIView *reuseCoverContainerView;
@property (strong, nonatomic) UIView *containerView;

// Animations
@property (strong, nonatomic) CAAnimationGroup *dragAnimationGroup;

@property (weak, nonatomic) UIView *overlayMask;
@property (weak, nonatomic) UIImageView *overlayImageView;

@end

@implementation ZLSwipeableView

#pragma mark - Accessors

- (void)setDataSource:(id <ZLSwipeableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self loadNextSwipeableViewsIfNeeded:NO];
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.animator.delegate = self;
    self.anchorContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self addSubview:self.anchorContainerView];
    self.isAnchorViewVisible = NO;
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.containerView];
    self.reuseCoverContainerView = [[UIView alloc] initWithFrame:self.bounds];
    self.reuseCoverContainerView.userInteractionEnabled = false;
    [self addSubview:self.reuseCoverContainerView];
    
    // Default properties
    self.isBehindViewsCustomizationEnabled = YES;
    self.isRotationEnabled = NO;
    self.isStackEnabled = YES;
    
    self.rotationDegree = 1;
    self.rotationRelativeYOffsetFromCenter = 0.3f;
    
    self.direction = ZLSwipeableViewDirectionAll;
    self.pushVelocityMagnitude = 1000;
    self.escapeVelocityThreshold = 750;
    self.relativeDisplacementThreshold = 0.25f;
    
    self.programaticSwipeRotationRelativeYOffsetFromCenter = -0.2;
    self.swipeableViewsCenter = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    self.swipeableViewsCenterInitial = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    self.collisionRect = [self defaultCollisionRect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.anchorContainerView.frame = CGRectMake(0, 0, 1, 1);
    self.containerView.frame = self.bounds;
    self.reuseCoverContainerView.frame = self.bounds;
    self.swipeableViewsCenterInitial = CGPointMake(
                                                   CGRectGetWidth(self.bounds) / 2 + self.swipeableViewsCenterInitial.x -
                                                   self.swipeableViewsCenter.x,
                                                   CGRectGetHeight(self.bounds) / 2 + self.swipeableViewsCenterInitial.y -
                                                   self.swipeableViewsCenter.y);
    self.swipeableViewsCenter = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
}

- (void)setSwipeableViewsCenter:(CGPoint)swipeableViewsCenter
{
    _swipeableViewsCenter = swipeableViewsCenter;
    [self animateSwipeableViewsIfNeeded];
}

#pragma mark - DataSource

- (void)discardAllSwipeableViews
{
    [self.animator removeBehavior:self.anchorViewAttachmentBehavior];
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)loadNextSwipeableViewsIfNeeded
{
    [self loadNextSwipeableViewsIfNeeded:NO];
}

- (void)loadNextSwipeableViewsIfNeeded:(BOOL)animated
{
    NSInteger numViews = self.containerView.subviews.count;
    NSMutableSet *newViews = [NSMutableSet set];
    for (NSInteger i = numViews; i < ZLPrefetchedViewsNumber; i++) {
        UIView *nextView = [self nextSwipeableView];
        if (nextView) {
            [self.containerView addSubview:nextView];
            [self.containerView sendSubviewToBack:nextView];
            nextView.center = self.swipeableViewsCenterInitial;
            [newViews addObject:nextView];
        }
    }
    
    if (animated) {
        NSTimeInterval maxDelay = 0.3f;
        NSTimeInterval delayStep = maxDelay / ZLPrefetchedViewsNumber;
        NSTimeInterval aggregatedDelay = maxDelay;
        NSTimeInterval animationDuration = 0.25f;
        for (UIView *view in newViews) {
            view.center = CGPointMake(view.center.x, -CGRectGetHeight(view.frame));
            [UIView animateWithDuration:animationDuration
                                  delay:aggregatedDelay
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 view.center = self.swipeableViewsCenter;
                             }
                             completion:nil];
            aggregatedDelay -= delayStep;
        }
        [self performSelector:@selector(animateSwipeableViewsIfNeeded)
                   withObject:nil
                   afterDelay:animationDuration];
    } else {
        [self animateSwipeableViewsIfNeeded];
    }
}

- (void)animateSwipeableViewsIfNeeded
{
    UIView *topSwipeableView = [self topSwipeableView];
    if (!topSwipeableView) {
        return;
    }
    
    for (UIView *cover in self.containerView.subviews) {
        cover.userInteractionEnabled = NO;
    }
    topSwipeableView.userInteractionEnabled = YES;
    
    for (UIGestureRecognizer *recognizer in topSwipeableView
         .gestureRecognizers) {
        if (recognizer.state != UIGestureRecognizerStatePossible) {
            return;
        }
    }
    
    if (self.isBehindViewsCustomizationEnabled) {
        
        NSUInteger numSwipeableViews = self.containerView.subviews.count;
        if (numSwipeableViews >= 1) {
            [self.animator removeBehavior:self.swipeableViewSnapBehavior];
            self.swipeableViewSnapBehavior = [self
                                              snapBehaviorThatSnapView:self.containerView
                                              .subviews[numSwipeableViews - 1]
                                              toPoint:self.swipeableViewsCenter];
            [self.animator addBehavior:self.swipeableViewSnapBehavior];
        }
        
        CGPoint rotationCenterOffset = {0, CGRectGetHeight(topSwipeableView.frame) * self.rotationRelativeYOffsetFromCenter};
        
        if (self.isStackEnabled && numSwipeableViews >= 2) {
            [self transformView:self.containerView.subviews[numSwipeableViews - 2] atIndex:1];
        } else if (self.isRotationEnabled && numSwipeableViews >= 2) {
            [self rotateView:self.containerView.subviews[numSwipeableViews - 2]
                   forDegree:self.rotationDegree
          atOffsetFromCenter:rotationCenterOffset
                    animated:YES];
        }
        
        if (self.isStackEnabled && numSwipeableViews >= 3) {
            [self transformView:self.containerView.subviews[numSwipeableViews - 3] atIndex:2];
        } else if (self.isRotationEnabled && numSwipeableViews >= 3) {
            [self rotateView:self.containerView.subviews[numSwipeableViews - 3]
                   forDegree:-self.rotationDegree
          atOffsetFromCenter:rotationCenterOffset
                    animated:YES];
        }
    }
}

#pragma mark - Action

static NSString * const kTransformBackViewAnimationKey = @"TransformBackViewAnimation";
static NSString * const kTransformMiddleViewAnimationKey = @"TransformMiddleViewAnimation";
static NSString * const kOverlayAppearanceAnimationKey = @"OverlayAppearanceAnimationKey";
static CGFloat const kRadiusFactor = 0.75;

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    CGPoint location = [recognizer locationInView:self];
    UIView *swipeableView = recognizer.view;
    

    CGPoint velocity = [recognizer velocityInView:self];
    CGFloat velocityMagnitude = sqrtf(powf(velocity.x, 2) + powf(velocity.y, 2));
    CGPoint normalizedVelocity = CGPointMake(velocity.x / velocityMagnitude, velocity.y / velocityMagnitude);
    CGFloat scale = velocityMagnitude > self.escapeVelocityThreshold ? velocityMagnitude : self.pushVelocityMagnitude;
    CGFloat translationMagnitude = sqrtf(translation.x * translation.x + translation.y * translation.y);
    CGVector directionVector = CGVectorMake(
                                            translation.x / translationMagnitude * scale,
                                            translation.y / translationMagnitude * scale
                                            );
    //Get the current overlay view
    FRDFriendDragableView *currentDragableView;
    UIView *currentOverlayMask;
    UIImageView *currentOverlayImageView;
    if ([swipeableView isKindOfClass:[FRDFriendDragableParentView class]]) {
        currentDragableView = ((FRDFriendDragableParentView *)swipeableView).friendDragableView;
        currentOverlayMask = currentDragableView.overlayView;
        currentOverlayImageView = currentDragableView.overlayImageView;
    }
    
    // Setup animations which will accompany swipeable view's movement
    NSUInteger numSwipeableViews = self.containerView.subviews.count;
    
    UIView *backView = nil;
    UIView *middleView = nil;
    CABasicAnimation *transformBackView = nil;
    CABasicAnimation *transformMiddleView = nil;
    
    if (numSwipeableViews >= 3) {
        backView = self.containerView.subviews[0];
        middleView = self.containerView.subviews[1];
        transformBackView = [self transformAnimationForView:backView atIndex:2];
        transformMiddleView = [self transformAnimationForView:middleView atIndex:1];
    } else if (numSwipeableViews == 2) {
        middleView = self.containerView.subviews[0];
        transformMiddleView = [self transformAnimationForView:middleView atIndex:1];
    }

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self createAnchorViewForCover:swipeableView atLocation:location shouldAttachAnchorViewToPoint:YES];
        
        if ([self.delegate respondsToSelector:@selector(swipeableView:didStartSwipingView:atLocation:)]) {
            [self.delegate swipeableView:self didStartSwipingView:swipeableView atLocation:location];
        }

        // Begin animating neccessary views
        if (middleView) {
            [backView.layer addAnimation:transformBackView forKey:kTransformBackViewAnimationKey];
            [middleView.layer addAnimation:transformMiddleView forKey:kTransformMiddleViewAnimationKey];
        }
 
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.anchorViewAttachmentBehavior.anchorPoint = location;
        if ([self.delegate respondsToSelector:@selector(swipeableView:swipingView:atLocation:translation:)]) {
            [self.delegate swipeableView:self swipingView:swipeableView atLocation:location translation:translation];
        }
        
        /*****Add overlay view if needed when swiping*****/
        ZLSwipeableViewDirection directionType = ZLDirectionVectorToSwipeableViewDirection(directionVector);
        
        if (currentOverlayImageView.isHidden && currentOverlayMask.isHidden && (directionType == ZLSwipeableViewDirectionLeft || directionType == ZLSwipeableViewDirectionRight)) {
            currentOverlayMask.hidden = NO;
            currentOverlayImageView.hidden = NO;
//            [currentOverlayImageView.layer addAnimation:[self appearAnimation] forKey:kOverlayAppearanceAnimationKey];
        }
        [self configureDragableFriendViewForOverlaying:currentDragableView withDirection:directionType];
        
        // Vector that points from the center of this view to the center of the swipeable view
        CGPoint distanceFromCenterVector = CGPointMake(swipeableView.center.x - self.swipeableViewsCenter.x,
                                                       swipeableView.center.y - self.swipeableViewsCenter.y);
        
        // Calculate absolut distance between two centers (this view's center and swipeable view's center)
        CGFloat swipeableViewDistanceFromCenter = ABS(sqrtf(distanceFromCenterVector.x * distanceFromCenterVector.x +
                                                            distanceFromCenterVector.y * distanceFromCenterVector.y));
        
        // Calculate the radius which will be used to normalize just calculated distance between centers
        CGFloat radius = self.swipeableViewsCenter.x * kRadiusFactor;
        
        // Normalize distance between centers and clip it to 1 if it's >1
        CGFloat normalizedDistance = MIN(1.f, swipeableViewDistanceFromCenter / radius);
        
        // Manually controll transform animations
        transformBackView.timeOffset = normalizedDistance;
        transformMiddleView.timeOffset = normalizedDistance;

        // Update layer's animations
        [backView.layer addAnimation:transformBackView forKey:kTransformBackViewAnimationKey];
        [middleView.layer addAnimation:transformMiddleView forKey:kTransformMiddleViewAnimationKey];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        /*****Remove overlay*****/
        if (!currentOverlayMask.isHidden && !currentOverlayImageView.isHidden) {
            currentOverlayMask.hidden = YES;
            currentOverlayImageView.hidden = YES;
        }

        if ((ZLDirectionVectorToSwipeableViewDirection(directionVector) & self.direction) > 0 &&
            (ABS(translation.x) > self.relativeDisplacementThreshold * self.bounds.size.width || // displacement
             velocityMagnitude > self.escapeVelocityThreshold) && // velocity
            (signum(translation.x) == signum(normalizedVelocity.x)) && // sign X
            (signum(translation.y) == signum(normalizedVelocity.y))) // sign Y
        {
            
            // Update model layer with destination values
            backView.layer.transform = ((NSValue *)transformBackView.toValue).CATransform3DValue;
            middleView.layer.transform = ((NSValue *)transformMiddleView.toValue).CATransform3DValue;
            
            // Remove drag animations (transform in our case)
            [backView.layer removeAnimationForKey:kTransformBackViewAnimationKey];
            [middleView.layer removeAnimationForKey:kTransformMiddleViewAnimationKey];
            
            /*****New delegate method*****/
            BOOL shouldRemoveView = NO;
            if ([self.delegate respondsToSelector:@selector(swipeableView:shouldRemoveView:withDirection:)]) {
                shouldRemoveView = [self.delegate swipeableView:self shouldRemoveView:swipeableView withDirection:self.direction];
            }
            
            if (shouldRemoveView) {
                [self pushAnchorViewForCover:swipeableView inDirection:directionVector andCollideInRect:self.collisionRect];
                /*****One more delegate method which needed for determine whether view was threw*****/
                ZLSwipeableViewDirection direction = ZLDirectionVectorToSwipeableViewDirection(directionVector);
                if ([self.delegate respondsToSelector:@selector(swipeableView:didThrowSwipingView:inDirection:)]) {
                    [self.delegate swipeableView:self didThrowSwipingView:swipeableView inDirection:direction];
                }
            }

        } else {
            [self.animator removeBehavior:self.swipeableViewAttachmentBehavior];
            [self.animator removeBehavior:self.anchorViewAttachmentBehavior];
            
            [self.anchorView removeFromSuperview];
            self.swipeableViewSnapBehavior = [self snapBehaviorThatSnapView:swipeableView
                                                                    toPoint:self.swipeableViewsCenter];
            [self.animator addBehavior:self.swipeableViewSnapBehavior];
            
            if ([self.delegate respondsToSelector:@selector(swipeableView:didCancelSwipe:)]) {
                [self.delegate swipeableView:self didCancelSwipe:swipeableView];
            }
            
            // Transform views back to starting values with animation
            transformBackView.speed = -1;
            transformBackView.duration = 0.2;
            [backView.layer addAnimation:transformBackView forKey:kTransformBackViewAnimationKey];
            
            transformMiddleView.speed = -1;
            transformMiddleView.duration = 0.2;
            [middleView.layer addAnimation:transformMiddleView forKey:kTransformMiddleViewAnimationKey];
        }
        
        if ([self.delegate respondsToSelector:@selector(swipeableView:didEndSwipingView:atLocation:)]) {
            [self.delegate swipeableView:self didEndSwipingView:swipeableView atLocation:location];
        }
    }
}

- (void)swipeTopViewToLeft
{
    [self swipeTopViewToLeft:YES];
}

- (void)swipeTopViewToRight
{
    [self swipeTopViewToLeft:NO];
}

- (void)swipeTopViewToUp
{
    [self swipeTopViewToUp:YES];
}

- (void)swipeTopViewToDown
{
    [self swipeTopViewToUp:NO];
}

- (void)swipeTopViewToLeft:(BOOL)left
{
    UIView *topSwipeableView = [self topSwipeableView];
    if (!topSwipeableView) {
        return;
    }
    
    //Get the current overlay view
    FRDFriendDragableView *currentDragableView;
    UIView *currentOverlayMask;
    UIImageView *currentOverlayImageView;
    if ([topSwipeableView isKindOfClass:[FRDFriendDragableParentView class]]) {
        currentDragableView = ((FRDFriendDragableParentView *)topSwipeableView).friendDragableView;
        currentOverlayImageView = currentDragableView.overlayImageView;
        currentOverlayMask = currentDragableView.overlayView;
    }
    
    CGPoint location = CGPointMake(
                                   topSwipeableView.center.x,
                                   topSwipeableView.center.y *
                                   (1 + self.programaticSwipeRotationRelativeYOffsetFromCenter));
    [self createAnchorViewForCover:topSwipeableView
                        atLocation:location
     shouldAttachAnchorViewToPoint:YES];
    CGVector direction =
    CGVectorMake((left ? -1 : 1) * self.escapeVelocityThreshold, 0);
    
    
    /***** Add overlay view if needed when press button *****/
    ZLSwipeableViewDirection directionType = ZLDirectionVectorToSwipeableViewDirection(direction);
    if (currentOverlayMask.isHidden && currentOverlayImageView.isHidden) {
        currentOverlayMask.hidden = NO;
        currentOverlayImageView.hidden = NO;
    }
    [self configureDragableFriendViewForOverlaying:currentDragableView withDirection:directionType];
    
    [self pushAnchorViewForCover:topSwipeableView
                     inDirection:direction
                andCollideInRect:self.collisionRect];
    /*****One more delegate method which needed for determine whether view was threw*****/
    if ([self.delegate respondsToSelector:@selector(swipeableView:didThrowSwipingView:inDirection:)]) {
        [self.delegate swipeableView:self didThrowSwipingView:topSwipeableView inDirection:directionType];
    }
}

- (void)swipeTopViewToUp:(BOOL)up
{
    UIView *topSwipeableView = [self topSwipeableView];
    if (!topSwipeableView) {
        return;
    }
    
    CGPoint location = CGPointMake(
                                   topSwipeableView.center.x,
                                   topSwipeableView.center.y *
                                   (1 + self.programaticSwipeRotationRelativeYOffsetFromCenter));
    [self createAnchorViewForCover:topSwipeableView
                        atLocation:location
     shouldAttachAnchorViewToPoint:YES];
    CGVector direction =
    CGVectorMake(0, (up ? -1 : 1) * self.escapeVelocityThreshold);
    [self pushAnchorViewForCover:topSwipeableView
                     inDirection:direction
                andCollideInRect:self.collisionRect];
}

#pragma mark - Drag Animations (CABasicAnimation)

- (CABasicAnimation *)transformAnimationForView:(UIView *)view atIndex:(NSInteger)index
{
    if (index < 1) {
        return nil;
    }
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CGAffineTransform startingTransform = [self transformForViewAtIndex:index];
    CATransform3D startingTransform3D = CATransform3DMakeAffineTransform(startingTransform);
    
    CGAffineTransform destinationTransform = [self transformForViewAtIndex:index - 1];
    CATransform3D destinationTransform3D = CATransform3DMakeAffineTransform(destinationTransform);
    
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:startingTransform3D];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:destinationTransform3D];
    transformAnimation.speed = 0.f;
    transformAnimation.duration = 1.01f;
    transformAnimation.timeOffset = 0.f;
    
    return transformAnimation;
}

- (CABasicAnimation *)appearAnimation
{
    UIView *topMostView = [self topSwipeableView];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @1.f;
    fadeAnimation.toValue = @0.f;
    fadeAnimation.speed = 0.f;
    fadeAnimation.duration = 1.01f;
    fadeAnimation.timeOffset= 0.f;
    
    return fadeAnimation;
}

#pragma mark - UIDynamicAnimationHelpers

- (UICollisionBehavior *)collisionBehaviorThatBoundsView:(UIView *)view
                                                  inRect:(CGRect)rect
{
    if (!view) {
        return nil;
    }
    UICollisionBehavior *collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[view]];
    UIBezierPath *collisionBound = [UIBezierPath bezierPathWithRect:rect];
    [collisionBehavior addBoundaryWithIdentifier:@"c" forPath:collisionBound];
    collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    return collisionBehavior;
}

- (UIPushBehavior *)pushBehaviorThatPushView:(UIView *)view
                                 toDirection:(CGVector)direction
{
    if (!view) {
        return nil;
    }
    UIPushBehavior *pushBehavior =
    [[UIPushBehavior alloc] initWithItems:@[view]
                                     mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = direction;
    return pushBehavior;
}

- (UISnapBehavior *)snapBehaviorThatSnapView:(UIView *)view
                                     toPoint:(CGPoint)point
{
    if (!view) {
        return nil;
    }
    UISnapBehavior *snapBehavior =
    [[UISnapBehavior alloc] initWithItem:view snapToPoint:point];
    snapBehavior.damping = 0.75f; /* Medium oscillation */
    return snapBehavior;
}

- (UIAttachmentBehavior *)attachmentBehaviorThatAnchorsView:(UIView *)aView
                                                     toView:(UIView *)anchorView
{
    if (!aView) {
        return nil;
    }
    CGPoint anchorPoint = anchorView.center;
    CGPoint p = [self convertPoint:aView.center toView:self];
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]
                                        initWithItem:aView
                                        offsetFromCenter:UIOffsetMake(-(p.x - anchorPoint.x),
                                                                      -(p.y - anchorPoint.y))
                                        attachedToItem:anchorView
                                        offsetFromCenter:UIOffsetMake(0, 0)];
    attachment.length = 0;
    return attachment;
}

- (UIAttachmentBehavior *)attachmentBehaviorThatAnchorsView:(UIView *)aView
                                                    toPoint:(CGPoint)aPoint
{
    if (!aView) {
        return nil;
    }
    
    CGPoint p = aView.center;
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc]
                                                initWithItem:aView
                                                offsetFromCenter:UIOffsetMake(-(p.x - aPoint.x), -(p.y - aPoint.y))
                                                attachedToAnchor:aPoint];
    attachmentBehavior.damping = 100;
    attachmentBehavior.length = 0;
    return attachmentBehavior;
}

- (void)createAnchorViewForCover:(UIView *)swipeableView
                      atLocation:(CGPoint)location
   shouldAttachAnchorViewToPoint:(BOOL)shouldAttachToPoint
{
    [self.animator removeBehavior:self.swipeableViewSnapBehavior];
    self.swipeableViewSnapBehavior = nil;
    
    self.anchorView =
    [[UIView alloc] initWithFrame:CGRectMake(location.x - 500,
                                             location.y - 500, 1000, 1000)];
    [self.anchorView setBackgroundColor:[UIColor blueColor]];
    [self.anchorView setHidden:!self.isAnchorViewVisible];
    [self.anchorContainerView addSubview:self.anchorView];
    UIAttachmentBehavior *attachToView =
    [self attachmentBehaviorThatAnchorsView:swipeableView
                                     toView:self.anchorView];
    [self.animator addBehavior:attachToView];
    self.swipeableViewAttachmentBehavior = attachToView;
    
    if (shouldAttachToPoint) {
        UIAttachmentBehavior *attachToPoint =
        [self attachmentBehaviorThatAnchorsView:self.anchorView
                                        toPoint:location];
        [self.animator addBehavior:attachToPoint];
        self.anchorViewAttachmentBehavior = attachToPoint;
    }
}

- (void)pushAnchorViewForCover:(UIView *)swipeableView
                   inDirection:(CGVector)directionVector
              andCollideInRect:(CGRect)collisionRect
{
    ZLSwipeableViewDirection direction = ZLDirectionVectorToSwipeableViewDirection(directionVector);
    
    if ([self.delegate respondsToSelector:@selector(swipeableView:didSwipeView:inDirection:)]) {
        [self.delegate swipeableView:self didSwipeView:swipeableView inDirection:direction];
    }
    
    [self.animator removeBehavior:self.anchorViewAttachmentBehavior];
    
    UICollisionBehavior *collisionBehavior = [self collisionBehaviorThatBoundsView:self.anchorView
                                                                            inRect:collisionRect];
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    UIPushBehavior *pushBehavior =
    [self pushBehaviorThatPushView:self.anchorView toDirection:directionVector];
    [self.animator addBehavior:pushBehavior];
    
    [self.reuseCoverContainerView addSubview:self.anchorView];
    [self.reuseCoverContainerView addSubview:swipeableView];
    [self.reuseCoverContainerView sendSubviewToBack:swipeableView];
    
    self.anchorView = nil;
    
    [self loadNextSwipeableViewsIfNeeded:NO];
    
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      endedContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier
{
    NSMutableSet *viewsToRemove = [[NSMutableSet alloc] init];
    
    for (id aBehavior in self.animator.behaviors) {
        if ([aBehavior isKindOfClass:[UIAttachmentBehavior class]]) {
            NSArray *items = ((UIAttachmentBehavior *) aBehavior).items;
            if ([items containsObject:item]) {
                [self.animator removeBehavior:aBehavior];
                [viewsToRemove addObjectsFromArray:items];
            }
        }
        if ([aBehavior isKindOfClass:[UIPushBehavior class]]) {
            NSArray *items = ((UIPushBehavior *) aBehavior).items;
            if ([((UIPushBehavior *) aBehavior).items containsObject:item]) {
                if ([items containsObject:item]) {
                    [self.animator removeBehavior:aBehavior];
                    [viewsToRemove addObjectsFromArray:items];
                }
            }
        }
        if ([aBehavior isKindOfClass:[UICollisionBehavior class]]) {
            NSArray *items = ((UICollisionBehavior *) aBehavior).items;
            if ([((UICollisionBehavior *) aBehavior).items
                 containsObject:item]) {
                if ([items containsObject:item]) {
                    [self.animator removeBehavior:aBehavior];
                    [viewsToRemove addObjectsFromArray:items];
                }
            }
        }
    }
    
    for (UIView *view in viewsToRemove) {
        for (UIGestureRecognizer *aGestureRecognizer in view
             .gestureRecognizers) {
            if ([aGestureRecognizer
                 isKindOfClass:[ZLPanGestureRecognizer class]]) {
                [view removeGestureRecognizer:aGestureRecognizer];
            }
        }
        [view removeFromSuperview];
    }
}

#pragma mark - ()

- (CGFloat)degreesToRadians:(CGFloat)degrees
{
    return degrees * M_PI / 180;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians
{
    return radians * 180 / M_PI;
}

int signum(CGFloat n)
{
    return (n < 0) ? -1 : (n > 0) ? +1 : 0;
}

- (CGRect)defaultCollisionRect
{
    CGSize viewSize = [UIScreen mainScreen].applicationFrame.size;
    CGFloat collisionSizeScale = 6;
    CGSize collisionSize = CGSizeMake(viewSize.width * collisionSizeScale,
                                      viewSize.height * collisionSizeScale);
    CGRect collisionRect =
    CGRectMake(-collisionSize.width / 2 + viewSize.width / 2,
               -collisionSize.height / 2 + viewSize.height / 2,
               collisionSize.width, collisionSize.height);
    return collisionRect;
}

- (UIView *)nextSwipeableView
{
    UIView *nextView = nil;
    if ([self.dataSource respondsToSelector:@selector(nextViewForSwipeableView:)]) {
        nextView = [self.dataSource nextViewForSwipeableView:self];
    }
    if (nextView) {
        [nextView
         addGestureRecognizer:[[ZLPanGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(handlePan:)]];
    }
    return nextView;
}

//Views rotating
- (void)rotateView:(UIView *)view
         forDegree:(float)degree
atOffsetFromCenter:(CGPoint)offset
          animated:(BOOL)animated
{
    float duration = animated ? .4f : 0;
    float rotationRadian = [self degreesToRadians:degree];
    [UIView animateWithDuration:duration animations:^{
        view.center = self.swipeableViewsCenter;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(offset.x,offset.y);
        transform = CGAffineTransformRotate(transform, rotationRadian);
        transform = CGAffineTransformTranslate(transform, -offset.x, -offset.y);
        view.transform = transform;
    }];
}

//Views stack
static CGFloat const kYOffset = 20.f;
- (void)transformView:(UIView *)view atIndex:(NSInteger)index
{
    [UIView animateWithDuration:.25f animations:^{
        view.center = self.swipeableViewsCenter;
        view.transform = [self transformForViewAtIndex:index];
    }];
}

- (CGAffineTransform)transformForViewAtIndex:(NSInteger)index
{
    CGFloat scaleCoef = 1 - index/kYOffset;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, kYOffset*index);
    transform = CGAffineTransformMakeScale(scaleCoef, scaleCoef);
    transform = CGAffineTransformTranslate(transform, 0, -kYOffset*index);
    return transform;
}

#pragma warning Temporary!

- (UIView *)topSwipeableView
{
    UIView *topSwipeableView = self.containerView.subviews.lastObject;
    return topSwipeableView;
}

#pragma mark - OverlayView
/*****Custom methods*****/
- (void)configureDragableFriendViewForOverlaying:(FRDFriendDragableView *)dragableView withDirection:(ZLSwipeableViewDirection)directionType
{
    if (directionType == ZLSwipeableViewDirectionLeft) {
        dragableView.overlayImageName = kDiscardIconName;
    } else if (directionType == ZLSwipeableViewDirectionRight) {
        dragableView.overlayImageName = kApplyIconName;
    }
}

@end