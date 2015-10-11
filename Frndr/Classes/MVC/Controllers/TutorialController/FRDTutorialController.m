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
#import "FRDFriendsListController.h"
#import "FRDContainerController.h"

#import "FRDSearchFriendsController.h"

#import "FRDFacebookService.h"
#import "FRDProjectFacade.h"

#import "FRDLocationObserver.h"

#import "FRDTermsLabel.h"
#import "FRDCustomPageControl.h"

#import "UIView+ConfigureAnchorPoint.h"
#import "CAAnimation+CompetionBlock.h"

#import "FRDAnimator.h"
#import "FRDRedirectionHelper.h"

#import "FRDAvatar.h"

#import "FRDChatManager.h"

@interface FRDTutorialController ()<TTTAttributedLabelDelegate, UIScrollViewDelegate, ContainerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
@property (weak, nonatomic) IBOutlet FRDCustomPageControl *tutorialPageControl;
@property (weak, nonatomic) IBOutlet FRDTermsLabel *termsLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (nonatomic) NSArray *contentImages;

@end

@implementation FRDTutorialController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContentImagesArray];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupTutorialScrollView];
        [self animateTutorialViews];
    });
    
    [FRDLocationObserver sharedObserver];
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
        
        CGFloat scrollHeight = CGRectGetHeight(self.tutorialScrollView.frame);
        CGFloat idx = 0;
        
        UIImageView *firstImage = [[UIImageView alloc] initWithImage:self.contentImages[0]];
        
        CGFloat imageWidth = CGRectGetWidth(firstImage.frame);
        CGFloat k = scrollHeight / CGRectGetHeight(firstImage.frame);
        imageWidth *= k;
        
        CGFloat distanceToBorder = (CGRectGetWidth(self.tutorialScrollView.frame) - imageWidth) / 2.f;
        
        idx += distanceToBorder;
        
        CGRect frame = CGRectMake(idx, 0.f, imageWidth, scrollHeight);
        firstImage.frame = frame;
        [self.tutorialScrollView addSubview:firstImage];
        
        for (NSInteger i = 1; i < self.contentImages.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.contentImages[i]];
            
            idx += distanceToBorder * 2 + imageWidth;
            
            CGRect frame = CGRectMake(idx, 0.f, imageWidth, scrollHeight);
            imageView.frame = frame;
            
            [self.tutorialScrollView addSubview:imageView];
        }
        
        CGSize contentSize = self.tutorialScrollView.frame.size;
        contentSize.width *= self.contentImages.count;
        self.tutorialScrollView.contentSize = contentSize;
    }
    
    [self showBottomViews];
    
}

/**
 *  By default these views are hidden. It helps avoid incorrect frames at beginning of animation
 */
- (void)showBottomViews
{
    [self.facebookButton setHidden:NO];
    [self.termsLabel setHidden:NO];
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
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDFacebookService authorizeWithFacebookInController:self onSuccess:^(BOOL isSuccess) {

        [FRDFacebookService getFacebookUserProfileOnSuccess:^(FRDFacebookProfile *facebookProfile) {
            
            //Init current user profile
            [FRDStorageManager sharedStorage].currentUserProfile = [FRDCurrentUserProfile userProfileWithFacebookProfile:facebookProfile];
            
            [FRDProjectFacade signInWithFacebookOnSuccess:^(NSString *userId, BOOL avatarExists, BOOL firstLogin) {
                
                [FRDStorageManager sharedStorage].currentUserProfile.userId = userId;
  
                //temp
                [FRDStorageManager sharedStorage].logined = YES;
                
                if (!avatarExists) {
                    
                    [weakSelf uploadAvatarOnSuccess:^(BOOL isSuccess) {
                        
                        if (firstLogin) {
                            [weakSelf updateCurrentProfileOnSuccess:^(BOOL isSuccess) {
                                
                                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                [weakSelf completeSuccessfullLogin];
                                
                            } onFailure:^(NSError *error, BOOL isCanceled) {
                                
                                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
                                
                            }];
                        } else {
                            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                            [weakSelf completeSuccessfullLogin];
                        }

                    } onFailure:^(NSError *error, BOOL isCanceled) {
                        
                        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
                        
                    }];
                    
                } else {
                    
                    [weakSelf getAvatarOnSuccess:^(BOOL isSuccess) {
                        
                        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                        [weakSelf completeSuccessfullLogin];
                        
                    } onFailure:^(NSError *error, BOOL isCanceled) {
                        
                        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
                        
                    }];
                }
                
            } onFailure:^(NSError *error, BOOL isCanceled) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
            }];

        } onFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
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
 *  Update profile if first login
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
- (void)updateCurrentProfileOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    [FRDProjectFacade updatedProfile:currentProfile onSuccess:^(FRDCurrentUserProfile *confirmedProfile) {
        
        [currentProfile updateWithUserProfile:confirmedProfile];
        
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
 *  Complete successfull login
 */
- (void)completeSuccessfullLogin
{
    [FRDFacebookService setLoginSuccess:YES];

    //Open socket channel
    [[FRDChatManager sharedChatManager] connectToHostAndListenEvents];
    
    [FRDRedirectionHelper redirectToMainContainerControllerWithNavigationController:(FRDBaseNavigationController *)self.navigationController andDelegate:self];
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
    NSArray *tutorialViewValues = @[@(-CGRectGetHeight(self.tutorialScrollView.frame)),
                                    @(CGRectGetMidY(self.tutorialScrollView.frame) + kTempOffset),
                                    @(CGRectGetMidY(self.tutorialScrollView.frame))];
    NSArray *facebookButtonValues = @[@(-CGRectGetHeight(self.facebookButton.frame)),
                                      @(CGRectGetMidY(self.facebookButton.frame) + kTempOffset),
                                      @(CGRectGetMidY(self.facebookButton.frame))];
    NSArray *termsLabelValues = @[@(-CGRectGetHeight(self.termsLabel.frame)),
                                  @(CGRectGetMidY(self.termsLabel.frame) + kTempOffset),
                                  @(CGRectGetMidY(self.termsLabel.frame))];
    NSArray *pageControlValues = @[@(-CGRectGetHeight(self.tutorialPageControl.frame)),
                                   @(CGRectGetMidY(self.tutorialPageControl.frame) + kTempOffset),
                                   @(CGRectGetMidY(self.tutorialPageControl.frame))];
    
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
    [FRDRedirectionHelper redirectToTermsAndServicesWithURL:url andPresentingController:self];
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

#pragma mark - ContainerViewControllerDelegate Protocol

- (id<UIViewControllerAnimatedTransitioning>)containerViewController:(FRDContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    return [[FRDAnimator alloc] init];
}

@end
