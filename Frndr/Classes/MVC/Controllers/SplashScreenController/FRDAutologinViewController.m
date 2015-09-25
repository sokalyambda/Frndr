//
//  FRDSplashScreenController.m
//  Frndr
//
//  Created by Pavlo on 9/14/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDAutologinViewController.h"
#import "FRDSearchFriendsController.h"
#import "FRDContainerController.h"

#import "FRDProjectFacade.h"

#import "FRDAnimator.h"
#import "FRDRedirectionHelper.h"

static NSString *const kTutorialSegueIdentifier = @"tutorialSegueIdentifier";

@interface FRDAutologinViewController ()<ContainerViewControllerDelegate>

@property (assign, nonatomic, getter=isFacebookSessionValid) BOOL facebookSessionValid;

@end

@implementation FRDAutologinViewController

#pragma mark - Accessors

- (BOOL)isFacebookSessionValid
{
    return [FRDProjectFacade isFacebookSessionValid];
}

#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkForRedirection];
}

#pragma mark - Actions

/**
 *  Check where we have to redirect the user, depends on previous sessions parameters.
 */
- (void)checkForRedirection
{
    if (self.isFacebookSessionValid) {
        [self autologinWithFacebook];
    } else {
        [self moveToTutorialAfterDelay:0.f];;
    }
}

/**
 *  Perform autologin with Facebook
 */
- (void)autologinWithFacebook
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [FRDProjectFacade signInWithFacebookOnSuccess:^(BOOL isSuccess) {
        
        //Init Current Profile
        FRDFacebookProfile *currentFacebookProfile = [FRDStorageManager sharedStorage].currentFacebookProfile;
        FRDCurrentUserProfile *currentProfile = [FRDCurrentUserProfile userProfileWithFacebookProfile:currentFacebookProfile];
        [FRDStorageManager sharedStorage].currentUserProfile = currentProfile;
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf moveToSearchFriendsController];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:^{
            [weakSelf moveToTutorialAfterDelay:0.f];
        }];
    }];
}

/**
 *  Show tutorial controller
 *
 *  @param delay Delay value
 */
- (void)moveToTutorialAfterDelay:(CGFloat)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:kTutorialSegueIdentifier sender:self];
    });
}

/**
 *  Show search friends controller
 */
- (void)moveToSearchFriendsController
{
    [FRDRedirectionHelper redirectToMainContainerControllerWithNavigationController:(FRDBaseNavigationController *)self.navigationController andDelegate:self];
}

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - ContainerViewControllerDelegate Protocol

- (id<UIViewControllerAnimatedTransitioning>)containerViewController:(FRDContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    return [[FRDAnimator alloc] init];
}

@end
