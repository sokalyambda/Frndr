
//
//  FRDSearchFriendsController.m
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSearchFriendsController.h"
#import "FRDPreferencesController.h"
#import "FRDFriendsListController.h"
#import "FRDPreviewGalleryController.h"

#import "FRDFriendDragableView.h"
#import "FRDFriendDragableParentView.h"
#import "FRDPulsingOverlayView.h"

#import "UIView+MakeFromXib.h"

#import "FRDProjectFacade.h"

#import "FRDNearestUser.h"

#import "FRDPushNotifiactionService.h"
#import "FRDNearestUsersService.h"

static NSString *const kPreferencesImageName = @"PreferencesIcon";
static NSString *const kMessagesImageName = @"MessagesIcon";

@interface FRDSearchFriendsController ()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) IBOutlet ZLSwipeableView *dragableViewsHolder;
@property (strong, nonatomic) IBOutlet FRDPulsingOverlayView *pulsingOverlay;

@property (weak, nonatomic) IBOutlet UILabel *interestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UIView *photosCollectionContainer;
@property (weak, nonatomic) IBOutlet UIView *likeButtonsContainer;

@property (nonatomic) FRDPreviewGalleryController *previewGalleryController;

@property (nonatomic) NSMutableArray *nearestUsers;
@property (nonatomic) FRDNearestUser *currentNearestUser;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger swipableViewsCounter;

@property (nonatomic, readonly) BOOL isOverlayPresented;

@end

@implementation FRDSearchFriendsController

#pragma mark - Accessors

- (NSString *)titleString
{
    return @"frndr";
}

- (NSString *)leftImageName
{
    return @"PreferencesIcon";
}

- (NSString *)rightImageName
{
    return @"MessagesIcon";
}

- (BOOL)isOverlayPresented
{
    return [self.view.subviews containsObject:self.pulsingOverlay];
}

- (void)setNearestUsers:(NSMutableArray *)nearestUsers
{
    _nearestUsers = nearestUsers;
    self.currentNearestUser = (FRDNearestUser *)nearestUsers.firstObject;
}

- (void)setCurrentNearestUser:(FRDNearestUser *)currentNearestUser
{
    _currentNearestUser = currentNearestUser;
    [self updateNearestUserInformation];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentPage = 1;
    self.swipableViewsCounter = 0;
    
    [FRDPushNotifiactionService registerApplicationForPushNotifications:[UIApplication sharedApplication]];
    
    [self setupPhotosGalleryContainer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupDragableViewOptions];
        [self setupPulsingOverlayView];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    //Show/hide like buttons container
//    [self changeButtonsContainerAlpha];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //updating actions
    [self performNeededUpdatingActions];
}

#pragma mark - Actions

- (IBAction)noClick:(id)sender
{
    [self.dragableViewsHolder swipeTopViewToLeft];
}

- (IBAction)yesClick:(id)sender
{
    [self.dragableViewsHolder swipeTopViewToRight];
}

/**
 *  Setup options for dragable view
 */
- (void)setupDragableViewOptions
{
    self.dragableViewsHolder.dataSource = self;
    self.dragableViewsHolder.direction = ZLSwipeableViewDirectionHorizontal;
}

- (void)setupPulsingOverlayView
{
    self.pulsingOverlay = [FRDPulsingOverlayView makeFromXibWithFileOwner:self];
}

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setupPhotosGalleryContainer
{
    self.previewGalleryController = [[FRDPreviewGalleryController alloc] initWithNibName:NSStringFromClass([FRDPreviewGalleryController class]) bundle:nil];
    [self.previewGalleryController.view setFrame:self.photosCollectionContainer.frame];
    [self.photosCollectionContainer addSubview:self.previewGalleryController.view];
    [self addChildViewController:self.previewGalleryController];
    [self.previewGalleryController didMoveToParentViewController:self];
}

#pragma mark - Updating Actions
- (void)getCurrentUserProfileOnSuccess:(void(^)(void))success onFailure:(void(^)(NSError *error))failure
{
    [FRDProjectFacade getCurrentUserProfileOnSuccess:^(BOOL isSuccess) {
        
        if (success) {
            success();
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

- (void)getCurrentSearchSettingsOnSuccess:(void(^)(void))success onFailure:(void(^)(NSError *error))failure
{
    [FRDProjectFacade getCurrentSearchSettingsOnSuccess:^(FRDSearchSettings *currentSearchSettings) {
        
        if (success) {
            success();
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 *  Perform needed updating actions
 */
- (void)performNeededUpdatingActions
{
    BOOL isUserUpdateNeeded = [FRDStorageManager sharedStorage].isUserProfileUpdateNeeded;
    BOOL isSearchSettingsUpdateNeeded = [FRDStorageManager sharedStorage].isSearchSettingsUpdateNeeded;
    
    WEAK_SELF;
    if (!self.isOverlayPresented) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    } else if (self.isOverlayPresented) {
        [self.pulsingOverlay addPulsingAnimations];
    }
    
    if (isUserUpdateNeeded && isSearchSettingsUpdateNeeded) {
        
        [self getCurrentUserProfileOnSuccess:^{
            
            [FRDStorageManager sharedStorage].userProfileUpdateNeeded = NO;
            
            [weakSelf getCurrentSearchSettingsOnSuccess:^{
                
                [FRDStorageManager sharedStorage].searchSettingsUpdateNeeded = NO;
                
                [weakSelf findNearestUsers];
                
            } onFailure:^(NSError *error) {
                
                [weakSelf findNearestUsers];
                
            }];
            
        } onFailure:^(NSError *error) {
            
            [weakSelf getCurrentSearchSettingsOnSuccess:^{
                
                [FRDStorageManager sharedStorage].searchSettingsUpdateNeeded = NO;
                
                [weakSelf findNearestUsers];
                
            } onFailure:^(NSError *error) {
                
                [weakSelf findNearestUsers];
                
            }];
        }];
        
    } else if (isUserUpdateNeeded) {
        
        [self getCurrentUserProfileOnSuccess:^{
            
            [FRDStorageManager sharedStorage].userProfileUpdateNeeded = NO;
            
            [weakSelf findNearestUsers];
            
        } onFailure:^(NSError *error) {
            
            [weakSelf findNearestUsers];
            
        }];
        
    } else if (isSearchSettingsUpdateNeeded) {
        
        [self getCurrentSearchSettingsOnSuccess:^{
            
            [FRDStorageManager sharedStorage].searchSettingsUpdateNeeded = NO;
            
            [weakSelf findNearestUsers];
            
        } onFailure:^(NSError *error) {
            
            [weakSelf findNearestUsers];
            
        }];
        
    } else {
        
        [self findNearestUsers];
        
    }
}

/**
 *  Find nearest users
 */
- (void)findNearestUsers
{
    WEAK_SELF;
    if (!self.nearestUsers.count && ![FRDNearestUsersService isSearchInProcess]) {
        if (!self.isOverlayPresented) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
    [FRDNearestUsersService getNearestUsersWithPage:self.currentPage onSuccess:^(NSArray *nearestUsers) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        weakSelf.nearestUsers = [nearestUsers mutableCopy];
        
        if (!weakSelf.nearestUsers.count) {
            weakSelf.currentPage = 1;
            [weakSelf showPulsingView];
        } else {
            [weakSelf dismissPulsingView];
        }
        
//        [weakSelf changeButtonsContainerAlpha];
        
    } onFailure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        
    }];
    } else {
        [self updateNearestUserInformation];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }
}

/**
 *  Configure overlap view
 */
- (void)showPulsingView
{
    if (!self.isOverlayPresented) {
        [self.pulsingOverlay showInView:self.view];
    }
}

- (void)dismissPulsingView
{
    if (self.isOverlayPresented) {
        [self.pulsingOverlay dismissFromView:self.view];
        [self updateNearestUserInformation];
    }
}

- (void)updatePulsingView
{
    if (self.isOverlayPresented) {
        [self.pulsingOverlay addPulsingAnimations];
    }
}

/**
 *  Update information relative to current nearest user
 */
- (void)updateNearestUserInformation
{
    self.biographyLabel.text = self.currentNearestUser.biography;
    
    NSMutableString *interests = [NSMutableString string];
    
    for (NSString *interest in self.currentNearestUser.thingsLovedMost) {
        [interests appendFormat:@"%@\n", interest];
    }
    
    self.interestsLabel.text = interests;
    
    self.swipableViewsCounter = 0;
    [self.dragableViewsHolder discardAllSwipeableViews];
    [self.dragableViewsHolder loadNextSwipeableViewsIfNeeded];
    
    self.previewGalleryController.photos = self.currentNearestUser.galleryPhotos;
}

/**
 *  Add constraints to avoid positioning issues
 *
 *  @param parentView  parentView
 *  @param contentView contentView
 */
- (void)addConstraintsForParentView:(UIView *)parentView andContentView:(UIView *)contentView
{
    NSDictionary *metrics = @{
                              @"height" : @(parentView.bounds.size.height),
                              @"width" : @(parentView.bounds.size.width)
                              };
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    [parentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[contentView(width)]"
      options:0
      metrics:metrics
      views:views]];
    [parentView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:
                                @"V:|[contentView(height)]"
                                options:0
                                metrics:metrics
                                views:views]];
}

/**
 *  Like current friend
 */
- (void)likeCurrentFriendOnSuccess:(void(^)(void))success onFalilure:(void(^)(NSError *error))failure
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade likeUserById:self.currentNearestUser.userId onSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (success) {
            success();
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 *  Dislike current friend
 */
- (void)dislikeCurrentFriendOnSuccess:(void(^)(void))success onFalilure:(void(^)(NSError *error))failure
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade dislikeUserById:self.currentNearestUser.userId onSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (success) {
            success();
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 *  Show/hide buttons container relative to nearest users array
 */
- (void)changeButtonsContainerAlpha
{
    WEAK_SELF;
    if (!self.nearestUsers.count) {
        [self.likeButtonsContainer setAlpha:1.f];
        [UIView animateWithDuration:.2f animations:^{
            [weakSelf.likeButtonsContainer setAlpha:0.f];
        } completion:nil];
    } else {
        [self.likeButtonsContainer setAlpha:0.f];
        [UIView animateWithDuration:.2f animations:^{
            [weakSelf.likeButtonsContainer setAlpha:1.f];
        } completion:nil];
    }
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    FRDFriendDragableParentView *parentView;
    
    if (self.nearestUsers.count && self.swipableViewsCounter < self.nearestUsers.count) {
    
        FRDNearestUser *currentNearesUser = self.nearestUsers[self.swipableViewsCounter];
    
        parentView = [[FRDFriendDragableParentView alloc] initWithFrame:swipeableView.bounds];
        FRDFriendDragableView *friendView = [FRDFriendDragableView makeFromXib];
        friendView.translatesAutoresizingMaskIntoConstraints = NO;
        [parentView addSubview:friendView];
        
        //bring overlay to front
        [friendView bringSubviewToFront:(UIView *)friendView.overlayView];
        
        [self addConstraintsForParentView:parentView andContentView:friendView];
        
        [friendView configureWithNearestUser:currentNearesUser];
    
        self.swipableViewsCounter++;
    }
    
    return parentView;
}

#pragma mark - ZLSwipeableViewDelegate

- (BOOL)swipeableView:(ZLSwipeableView *)swipeableView
     shouldRemoveView:(UIView *)view
        withDirection:(ZLSwipeableViewDirection)direction
{
    return YES;
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction
{
    
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view
{

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didStartSwipingView:(UIView *)view atLocation:(CGPoint)location
{

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location translation:(CGPoint)translation
{

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location
{
    
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didThrowSwipingView:(UIView *)swipingView inDirection:(ZLSwipeableViewDirection)direction
{
    /*****Like&dislike nearest users*****/
    WEAK_SELF;
    switch (direction) {
        case ZLSwipeableViewDirectionLeft: {
            
            [self dislikeCurrentFriendOnSuccess:^{

                [weakSelf checkNearestUsersInformationOrLoadMore];
                
            } onFalilure:^(NSError *error) {
                
                [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
                
            }];
            
            break;
        }
        case ZLSwipeableViewDirectionRight: {
            
            [self likeCurrentFriendOnSuccess:^{

                [weakSelf checkNearestUsersInformationOrLoadMore];
                
            } onFalilure:^(NSError *error) {
                
                [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
                
            }];
            
            break;
        }
        default:
            break;
    }
    
//    [self checkNearestUsersInformationOrLoadMore];
}

- (void)checkNearestUsersInformationOrLoadMore
{
    if (self.nearestUsers.count) {
        [self.nearestUsers removeObject:self.nearestUsers.firstObject];
    }
    
    if (self.nearestUsers.count) {
        self.currentNearestUser = self.nearestUsers.firstObject;
        [self updateNearestUserInformation];
    }
    
    if (!self.nearestUsers.count) {
        self.swipableViewsCounter = 0;
        self.currentPage++;
        [self findNearestUsers];
    }
}

@end
