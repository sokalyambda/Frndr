//
//  FRDTutorialController.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDTutorialController.h"
#import "FRDTermsAndServicesController.h"
#import "FRDBaseNavigationController.h"
#import "FRDPreferencesController.h"

#import "FRDFacebookService.h"

#import "FRDTermsLabel.h"
#import "FRDCustomPageControl.h"

#import "UIView+ConfigureAnchorPoint.h"
#import "CAAnimation+CompetionBlock.h"

@interface FRDTutorialController ()<TTTAttributedLabelDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
@property (weak, nonatomic) IBOutlet FRDCustomPageControl *tutorialPageControl;
@property (weak, nonatomic) IBOutlet FRDTermsLabel *termsLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (strong, nonatomic) NSArray *contentImages;

@end

@implementation FRDTutorialController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContentImagesArray];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupTutorialScrollView];
        [self animateTutorialViews];
    });
}

#pragma mark - Actions

- (void)initContentImagesArray
{
    self.contentImages = @[
                           [UIImage imageNamed:@"Tutorial01"],
                           [UIImage imageNamed:@"Tutorial02"],
                           [UIImage imageNamed:@"Tutorial03"]
                           ];
}

/**
 *  Setup tutorial scroll view with contentImages
 */
- (void)setupTutorialScrollView
{
    if (self.contentImages.count) {
        
        self.tutorialPageControl.numberOfPages = self.contentImages.count;
        self.tutorialPageControl.defersCurrentPageDisplay = YES;
        
        CGFloat scrollWidth = CGRectGetWidth(self.tutorialScrollView.frame);
        CGFloat scrollHeight = CGRectGetHeight(self.tutorialScrollView.frame);
        CGFloat idx = 0;
        
        for (NSInteger i = 0; i < self.contentImages.count; i++) {
            UIImageView *imaqeView = [[UIImageView alloc] initWithImage:self.contentImages[i]];
            CGRect frame = CGRectMake(idx, 0.f, scrollWidth, scrollHeight);
            imaqeView.frame = frame;
            [self.tutorialScrollView addSubview:imaqeView];
            idx += scrollWidth;
        }
        
        CGSize contentSize = self.tutorialScrollView.frame.size;
        contentSize.width *= self.contentImages.count;
        self.tutorialScrollView.contentSize = contentSize;
    }
}

/**
 *  Update the page control
 *
 *  @param idx Current page index
 */
- (void)updatePageControlWithIndex:(NSUInteger)idx
{
    self.tutorialPageControl.currentPage = idx;
}

/**
 *  Customize navigation item
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/**
 *  Try authorize with Facebook
 */
- (void)authorizeWithFacebookAction
{
    FRDPreferencesController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDPreferencesController class])];
    [self.navigationController pushViewController:controller animated:YES];
    /*
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDFacebookService authorizeWithFacebookOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        FRDPreferencesController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDPreferencesController class])];
        [weakSelf.navigationController pushViewController:controller animated:YES];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
     */
}

/**
 *  Animate the tutorial views
 */
static NSInteger const kTempOffset = 8.f;
static CGFloat const kTutorialAnimDuration = .9f;
static CGFloat const kFBButtonAnimDuration = .8f;
static CGFloat const kTermsLabelAnimDuration = .7f;
static CGFloat const kPageControlAnimDuration = .6f;
- (void)animateTutorialViews
{
    NSArray *tutorialViewValues = @[@(-CGRectGetHeight(self.tutorialScrollView.frame)), @(CGRectGetMidY(self.tutorialScrollView.frame) + kTempOffset), @(CGRectGetMidY(self.tutorialScrollView.frame))];
    NSArray *facebookButtonValues = @[@(-CGRectGetHeight(self.facebookButton.frame)), @(CGRectGetMidY(self.facebookButton.frame) + kTempOffset), @(CGRectGetMidY(self.facebookButton.frame))];
    NSArray *termsLabelValues = @[@(-CGRectGetHeight(self.termsLabel.frame)), @(CGRectGetMidY(self.termsLabel.frame) + kTempOffset), @(CGRectGetMidY(self.termsLabel.frame))];
    NSArray *pageControlValues = @[@(-CGRectGetHeight(self.tutorialPageControl.frame)), @(CGRectGetMidY(self.tutorialPageControl.frame) + kTempOffset), @(CGRectGetMidY(self.tutorialPageControl.frame))];
    
    CAKeyframeAnimation *tutorialViewFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    CAKeyframeAnimation *facebookButtonFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    CAKeyframeAnimation *termsLabelFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    CAKeyframeAnimation *pageControlFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    
    tutorialViewFrameAnimation.values = tutorialViewValues;
    facebookButtonFrameAnimation.values = facebookButtonValues;
    termsLabelFrameAnimation.values = termsLabelValues;
    pageControlFrameAnimation.values = pageControlValues;
    
    tutorialViewFrameAnimation.duration = kTutorialAnimDuration;
    facebookButtonFrameAnimation.duration = kFBButtonAnimDuration;
    termsLabelFrameAnimation.duration = kTermsLabelAnimDuration;
    pageControlFrameAnimation.duration = kPageControlAnimDuration;

    [self.tutorialScrollView.layer addAnimation:tutorialViewFrameAnimation forKey:@"position.y"];
    [self.facebookButton.layer addAnimation:facebookButtonFrameAnimation forKey:@"position.y"];
    [self.termsLabel.layer addAnimation:termsLabelFrameAnimation forKey:@"position.y"];
    [self.tutorialPageControl.layer addAnimation:pageControlFrameAnimation forKey:@"position.y"];
}

- (IBAction)facebookLoginClick:(id)sender
{
    [self authorizeWithFacebookAction];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    FRDTermsAndServicesController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDTermsAndServicesController class])];
    FRDBaseNavigationController *navigationController = [[FRDBaseNavigationController alloc] initWithRootViewController:controller];
    controller.currentURL = url;

    [self presentViewController:navigationController animated:YES completion:nil];
    NSLog(@"url string %@", url.absoluteString);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    [self updatePageControlWithIndex:page];
}

#pragma mark - UIStatusBar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
