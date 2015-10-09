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

#import "FRDAvatar.h"

#import "FRDChatManager.h"

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
    [FRDProjectFacade signInWithFacebookOnSuccess:^(NSString *userId, BOOL avatarExists, BOOL firstLogin) {
        
        //Init Current Profile
        FRDFacebookProfile *currentFacebookProfile = [FRDStorageManager sharedStorage].currentFacebookProfile;
        FRDCurrentUserProfile *currentProfile = [FRDCurrentUserProfile userProfileWithFacebookProfile:currentFacebookProfile];
        currentProfile.userId = userId;
        [FRDStorageManager sharedStorage].currentUserProfile = currentProfile;
        
        //Open socket channel
        [[FRDChatManager sharedChatManager] connectToHostAndListenEvents];
        
        if (!avatarExists) {
            
            [weakSelf uploadAvatarOnSuccess:^(BOOL isSuccess) {
                
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [weakSelf moveToSearchFriendsController];
                
            } onFailure:^(NSError *error, BOOL isCanceled) {
                
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:^{
                    [weakSelf moveToTutorialAfterDelay:0.f];
                }];
                
            }];

        } else {
            //get avatar
            [weakSelf getAvatarOnSuccess:^(BOOL isSuccess) {
                
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [weakSelf moveToSearchFriendsController];
                
            } onFailure:^(NSError *error, BOOL isCanceled) {
                
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:^{
                    [weakSelf moveToTutorialAfterDelay:0.f];
                }];
            }];
        }
  
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:^{
            [weakSelf moveToTutorialAfterDelay:0.f];
        }];
    }];
}

/**
 *  Get avatar request
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
- (void)getAvatarOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [FRDProjectFacade getAvatarWithSmallValue:NO onSuccess:^(FRDAvatar *avatar) {
        
        //set avatar, it has been existed already
        [FRDStorageManager sharedStorage].currentUserProfile.currentAvatar = avatar;
        
        if (success) {
            success(YES);
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error, isCanceled);
        }
        
    }];
}

/**
 *  Upload avatar if it doesn't exist
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
- (void)uploadAvatarOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    //download the avatar image
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[FRDStorageManager sharedStorage].currentUserProfile.avatarURL options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        if (image) {
            
            [FRDProjectFacade uploadUserAvatar:image onSuccess:^(BOOL isSuccess) {
                
                //assign avatar facebook URL to current avatar
                [FRDStorageManager sharedStorage].currentUserProfile.currentAvatar.photoURL = [FRDStorageManager sharedStorage].currentUserProfile.avatarURL;
                
                if (success) {
                    success(YES);
                }
                
            } onFailure:^(NSError *error, BOOL isCanceled) {
                
                if (failure) {
                    failure(error, isCanceled);
                }
                
            }];
            
        } else {
            if (failure) {
                failure(error, NO);
            }
        }
        
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
