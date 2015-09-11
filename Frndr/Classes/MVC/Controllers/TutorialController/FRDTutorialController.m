//
//  FRDTutorialController.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDTutorialController.h"
#import "FRDTutorialContentController.h"

#import "FRDFacebookService.h"

#import "FRDTermsLabel.h"

#import "UIView+ConfigureAnchorPoint.h"
#import "CAAnimation+CompetionBlock.h"

@interface FRDTutorialController ()<UIPageViewControllerDataSource, UITextViewDelegate, TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *tutorialContainer;
@property (weak, nonatomic) IBOutlet FRDTermsLabel *termsLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (strong, nonatomic) NSArray *contentImages;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (assign, nonatomic) NSUInteger presentationIndex;

@end

@implementation FRDTutorialController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createPageViewController];
    [self setupPageControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self animateTutorialViews];
}

#pragma mark - Actions

/**
 *  Create page view controller
 */
- (void)createPageViewController
{
    self.contentImages = @[@"tutorial01",
                      @"tutorial02",
                      @"tutorial03"];
    
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageController"];
    pageController.dataSource = self;
    
    if([self.contentImages count]) {
        NSArray *startingViewControllers = @[[self itemControllerForIndex:0]];
        [pageController setViewControllers:startingViewControllers
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:YES
                                completion:nil];
    }
    
    self.pageViewController = pageController;
    [self addChildViewController:self.pageViewController];
    [self.pageViewController.view setFrame:self.tutorialContainer.bounds];
    [self.tutorialContainer addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

/**
 *  Setup page control appearance
 */
- (void)setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor whiteColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor blueColor]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor lightGrayColor]];
}

/**
 *  Customize navigation item
 */
- (void)customizeNavigationItem
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/**
 *  Try authorize with Facebook
 */
- (void)authorizeWithFacebookAction
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDFacebookService authorizeWithFacebookOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

/**
 *  Animate the tutorial views
 */
static NSInteger const kTempOffset = 8.f;
static CGFloat const kTutorialAnimDuration = .8f;
static CGFloat const kFBButtonAnimDuration = .7f;
static CGFloat const kTermsLabelAnimDuration = .6f;
- (void)animateTutorialViews
{
    NSArray *tutorialViewValues = @[@(-CGRectGetHeight(self.tutorialContainer.frame)), @(CGRectGetMidY(self.tutorialContainer.frame) + kTempOffset), @(CGRectGetMidY(self.tutorialContainer.frame))];
    NSArray *facebookButtonValues = @[@(-CGRectGetHeight(self.facebookButton.frame)), @(CGRectGetMidY(self.facebookButton.frame) + kTempOffset), @(CGRectGetMidY(self.facebookButton.frame))];
    NSArray *termsLabelValues = @[@(-CGRectGetHeight(self.termsLabel.frame)), @(CGRectGetMidY(self.termsLabel.frame) + kTempOffset), @(CGRectGetMidY(self.termsLabel.frame))];
    
    CAKeyframeAnimation *tutorialViewFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    CAKeyframeAnimation *facebookButtonFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    CAKeyframeAnimation *termsLabelFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    
    tutorialViewFrameAnimation.values = tutorialViewValues;
    facebookButtonFrameAnimation.values = facebookButtonValues;
    termsLabelFrameAnimation.values = termsLabelValues;
    
    tutorialViewFrameAnimation.duration = kTutorialAnimDuration;
    facebookButtonFrameAnimation.duration = kFBButtonAnimDuration;
    termsLabelFrameAnimation.duration = kTermsLabelAnimDuration;

    [self.tutorialContainer.layer addAnimation:tutorialViewFrameAnimation forKey:@"position.y"];
    [self.facebookButton.layer addAnimation:facebookButtonFrameAnimation forKey:@"position.y"];
    [self.termsLabel.layer addAnimation:termsLabelFrameAnimation forKey:@"position.y"];
}

- (IBAction)facebookLoginClick:(id)sender
{
    [self authorizeWithFacebookAction];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    FRDTutorialContentController *itemController = (FRDTutorialContentController *)viewController;
    NSUInteger index = itemController.itemIndex;
    
    if (index == 0 || index == NSNotFound) {
        index = [self.contentImages count];
    }
    
    --index;
    
    return [self itemControllerForIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    FRDTutorialContentController *itemController = (FRDTutorialContentController *) viewController;
    NSUInteger index = itemController.itemIndex;
    
    ++index;
    
    if (index == self.contentImages.count || index == NSNotFound) {
        index = 0;
    }
    
    return [self itemControllerForIndex:index];
}

- (FRDTutorialContentController *)itemControllerForIndex:(NSUInteger)itemIndex
{
    self.presentationIndex = itemIndex;
    
    FRDTutorialContentController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDTutorialContentController class])];
    
    pageItemController.itemIndex = itemIndex;
    pageItemController.imageName = self.contentImages[itemIndex];
    
    return pageItemController;
}

#pragma mark - Page Indicator

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.contentImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.presentationIndex;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"url string %@", url.absoluteString);
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){return;}
    
    // Find index of current page
    FRDTutorialContentController *currentViewController = (FRDTutorialContentController *)[self.pageViewController.viewControllers lastObject];
    NSUInteger indexOfCurrentPage = currentViewController.itemIndex;
//    self.pageViewController  = indexOfCurrentPage;
}


@end
