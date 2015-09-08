//
//  FRDTutorialController.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDTutorialController.h"
#import "FRDTutorialContentController.h"

@interface FRDTutorialController ()<UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIView *tutorialContainer;

@property (strong, nonatomic) NSArray *contentImages;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation FRDTutorialController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createPageViewController];
    [self setupPageControl];
}

#pragma mark - Actions

- (void)createPageViewController
{
    self.contentImages = @[@"nature_pic_1",
                      @"nature_pic_2",
                      @"nature_pic_3",
                      @"nature_pic_4"];
    
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageController"];
    pageController.dataSource = self;
    
    if([self.contentImages count]) {
        NSArray *startingViewControllers = @[[self itemControllerForIndex: 0]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.pageViewController = pageController;
    [self addChildViewController: self.pageViewController];
    [self.pageViewController.view setFrame:self.tutorialContainer.bounds];
    [self.tutorialContainer addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController: self];
}

- (void)setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor redColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor darkGrayColor]];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController
{
    FRDTutorialContentController *itemController = (FRDTutorialContentController *)viewController;
    
    if (itemController.itemIndex > 0) {
        return [self itemControllerForIndex: itemController.itemIndex-1];
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    FRDTutorialContentController *itemController = (FRDTutorialContentController *) viewController;
    
    if (itemController.itemIndex + 1 < [self.contentImages count]) {
        return [self itemControllerForIndex: itemController.itemIndex + 1];
    }
    
    return nil;
}

- (FRDTutorialContentController *)itemControllerForIndex:(NSUInteger)itemIndex
{
    if (itemIndex < [self.contentImages count]) {
        FRDTutorialContentController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDTutorialContentController class])];
        pageItemController.itemIndex = itemIndex;
        pageItemController.imageName = self.contentImages[itemIndex];
        return pageItemController;
    }
    
    return nil;
}

#pragma mark - Page Indicator

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.contentImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end
