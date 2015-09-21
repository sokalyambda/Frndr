//
//  FRDContainerController.m
//  Frndr
//
//  Created by Eugenity on 21.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDContainerController.h"
#import "FRDBaseContentController.h"

#import "FRDTopContentView.h"

#import "UIView+MakeFromXib.h"

/** A private UIViewControllerContextTransitioning class to be provided transitioning delegates.
 @discussion Because we are a custom UIVievController class, with our own containment implementation, we have to provide an object conforming to the UIViewControllerContextTransitioning protocol. The system view controllers use one provided by the framework, which we cannot configure, let alone create. This class will be used even if the developer provides their own transitioning objects.
 @note The only methods that will be called on objects of this class are the ones defined in the UIViewControllerContextTransitioning protocol. The rest is our own private implementation.
 */
@interface PrivateTransitionContext : NSObject <UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight; /// Designated initializer.
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete); /// A block of code we can set to execute after having received the completeTransition: message.
@property (nonatomic, assign, getter=isAnimated) BOOL animated; /// Private setter for the animated property.
@property (nonatomic, assign, getter=isInteractive) BOOL interactive; /// Private setter for the interactive property.

@end

/** Instances of this private class perform the default transition animation which is to slide child views horizontally.
 @note The class only supports UIViewControllerAnimatedTransitioning at this point. Not UIViewControllerInteractiveTransitioning.
 */
@interface PrivateAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
@end

#pragma mark -

@interface FRDContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *privateButtonsView; /// The view hosting the buttons of the child view controllers.
@property (weak, nonatomic) IBOutlet UIView *privateContainerView; /// The view hosting the child view controllers views.

@property (nonatomic) IBOutlet FRDTopContentView *topContentView;

@property (assign, nonatomic) NSInteger currentPageIndex;

@end

@implementation FRDContainerViewController

#pragma mark - Accessors

- (void)setSelectedViewController:(FRDBaseContentController *)selectedViewController
{
    NSParameterAssert (selectedViewController);
    [self transitionToChildViewController:selectedViewController];
    _selectedViewController = selectedViewController;
    [self updateCustomTopView];
}

#pragma mark - Lifecycle

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    NSParameterAssert ([viewControllers count] > 0);
    if ((self = [super init])) {
        self.viewControllers = [viewControllers copy];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FRDTopContentView *topView = [FRDTopContentView makeFromXibWithFileOwner:self];
        topView.frame = self.privateButtonsView.frame;
        [self.privateButtonsView addSubview:topView];
        self.currentPageIndex = 1;
        self.selectedViewController = (self.selectedViewController ?: self.viewControllers[self.currentPageIndex]);
    });
}

#pragma mark - UIStatusBar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.selectedViewController;
}

#pragma mark - Actions

- (IBAction)buttonTapped:(UISwipeGestureRecognizer *)swipeGesture
{
    UISwipeGestureRecognizerDirection currentDirection = swipeGesture.direction;
    
    if (currentDirection == UISwipeGestureRecognizerDirectionRight) {
        if (self.currentPageIndex > 0) {
            self.currentPageIndex--;
        } else {
            return;
        }
    } else if (currentDirection == UISwipeGestureRecognizerDirectionLeft) {
        if (self.currentPageIndex < self.viewControllers.count - 1) {
            self.currentPageIndex++;
        } else {
            return;
        }
    }
    
    FRDBaseContentController *selectedViewController = self.viewControllers[self.currentPageIndex];
    self.selectedViewController = selectedViewController;
    
    if ([self.delegate respondsToSelector:@selector (containerViewController:didSelectViewController:)]) {
        [self.delegate containerViewController:self didSelectViewController:selectedViewController];
    }
}

/**
 *  Update top nav view for current controller
 */
- (void)updateCustomTopView
{
    [self.selectedViewController customizeTopView:self.topContentView];
}

- (void)transitionToChildViewController:(FRDBaseContentController *)toViewController
{
    FRDBaseContentController *fromViewController = ([self.childViewControllers count] > 0 ? self.childViewControllers[0] : nil);
    if (toViewController == fromViewController || ![self isViewLoaded]) {
        return;
    }
    
    UIView *toView = toViewController.view;
    
    toView.frame = self.privateContainerView.bounds;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    // If this is the initial presentation, add the new child with no animation.
    if (!fromViewController) {
        [self.privateContainerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
        return;
    }
    
    // Animate the transition by calling the animator with our private transition context. If we don't have a delegate, or if it doesn't return an animated transitioning object, we will use our own, private animator.
    
    id<UIViewControllerAnimatedTransitioning>animator = nil;
    if ([self.delegate respondsToSelector:@selector (containerViewController:animationControllerForTransitionFromViewController:toViewController:)]) {
        animator = [self.delegate containerViewController:self animationControllerForTransitionFromViewController:fromViewController toViewController:toViewController];
    }
    animator = (animator ?: [[PrivateAnimatedTransition alloc] init]);
    
    // Because of the nature of our view controller, with horizontally arranged buttons, we instantiate our private transition context with information about whether this is a left-to-right or right-to-left transition. The animator can use this information if it wants.
    NSUInteger fromIndex = [self.viewControllers indexOfObject:fromViewController];
    NSUInteger toIndex = [self.viewControllers indexOfObject:toViewController];
    PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:toIndex > fromIndex];
    
    transitionContext.animated = YES;
    transitionContext.interactive = NO;
    transitionContext.completionBlock = ^(BOOL didComplete) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
        self.privateButtonsView.userInteractionEnabled = YES;
    };
    
    self.privateButtonsView.userInteractionEnabled = NO; // Prevent user tapping buttons mid-transition, messing up state
    [animator animateTransition:transitionContext];
}

@end

#pragma mark - Private Transitioning Classes

@interface PrivateTransitionContext ()

@property (nonatomic) NSDictionary *privateViewControllers;
@property (nonatomic) CGRect privateDisappearingFromRect;
@property (nonatomic) CGRect privateAppearingFromRect;
@property (nonatomic) CGRect privateDisappearingToRect;
@property (nonatomic) CGRect privateAppearingToRect;
@property (weak, nonatomic) UIView *containerView;
@property (nonatomic) UIModalPresentationStyle presentationStyle;

@end

@implementation PrivateTransitionContext

- (instancetype)initWithFromViewController:(FRDBaseContentController *)fromViewController toViewController:(FRDBaseContentController *)toViewController goingRight:(BOOL)goingRight
{
    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        self.privateViewControllers = @{
                                        UITransitionContextFromViewControllerKey:fromViewController,
                                        UITransitionContextToViewControllerKey:toViewController,
                                        };
        
        // Set the view frame properties which make sense in our specialized ContainerViewController context. Views appear from and disappear to the sides, corresponding to where the icon buttons are positioned. So tapping a button to the right of the currently selected, makes the view disappear to the left and the new view appear from the right. The animator object can choose to use this to determine whether the transition should be going left to right, or right to left, for example.
        CGFloat travelDistance = (goingRight ? -CGRectGetWidth(self.containerView.bounds) : CGRectGetWidth(self.containerView.bounds));
        self.privateDisappearingFromRect = self.privateAppearingToRect = self.containerView.bounds;
        self.privateDisappearingToRect = CGRectOffset (self.containerView.bounds, travelDistance, 0);
        self.privateAppearingFromRect = CGRectOffset (self.containerView.bounds, -travelDistance, 0);
    }
    
    return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController
{
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingFromRect;
    } else {
        return self.privateAppearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController
{
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingToRect;
    } else {
        return self.privateAppearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key
{
    return self.privateViewControllers[key];
}

- (void)completeTransition:(BOOL)didComplete
{
    if (self.completionBlock) {
        self.completionBlock(didComplete);
    }
}

- (BOOL)transitionWasCancelled { return NO; } // Our non-interactive transition can't be cancelled (it could be interrupted, though)

// Supress warnings by implementing empty interaction methods for the remainder of the protocol:
- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}

@end

@implementation PrivateAnimatedTransition

static CGFloat const kChildViewPadding = 16;
static CGFloat const kDamping = 0.75;
static CGFloat const kInitialSpringVelocity = 0.5;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

/// Slide views horizontally, with a bit of space between, while fading out and in.
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
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:kDamping initialSpringVelocity:kInitialSpringVelocity options:0x00 animations:^{
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
