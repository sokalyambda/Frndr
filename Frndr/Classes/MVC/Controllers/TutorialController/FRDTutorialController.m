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

@interface FRDTutorialController ()<UIPageViewControllerDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tutorialContainer;

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
    [self customizeViews];
}

#pragma mark - Actions

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

- (void)setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor whiteColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor blueColor]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)customizeNavigationItem
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)customizeViews
{
}

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

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}


@end
