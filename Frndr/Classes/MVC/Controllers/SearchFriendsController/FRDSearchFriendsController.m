
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

#import "UIView+MakeFromXib.h"

#import "FRDProjectFacade.h"

#import "FRDNearestUser.h"

static NSString *const kPreferencesImageName = @"PreferencesIcon";
static NSString *const kMessagesImageName = @"MessagesIcon";

@interface FRDSearchFriendsController ()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) IBOutlet ZLSwipeableView *dragableViewsHolder;

@property (weak, nonatomic) IBOutlet UILabel *interestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UIView *photosCollectionContainer;

@property (nonatomic) FRDPreviewGalleryController *previewGalleryController;

@property (nonatomic) NSMutableArray *nearestUsers;
@property (nonatomic) FRDNearestUser *currentNearestUser;

@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger swipableViewsCounter;

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
    
    [self setupPhotosGalleryContainer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupDragableViewOptions];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"nearest users %@ and it's count is %d", self.nearestUsers, self.nearestUsers.count);
//    [self performNeededUpdateAction];
    [self getCurrentUserProfile];
    if (!self.nearestUsers.count) {
        [self findNearestUsers];
    }
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

- (void)setupDragableViewOptions
{
    self.dragableViewsHolder.dataSource = self;
    self.dragableViewsHolder.direction = ZLSwipeableViewDirectionHorizontal;
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

- (void)getCurrentUserProfile
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getCurrentUserProfileOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

/**
 *  Update current profile
 */
//- (void)updateCurrentProfileOnSuccess:(void(^)(void))success onFailure:(void(^)(NSError *error))failure
//{
//    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
//
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [FRDProjectFacade updatedProfile:currentProfile onSuccess:^(FRDCurrentUserProfile *confirmedProfile) {
//        
//        if (success) {
//            success();
//        }
//        
//    } onFailure:^(NSError *error, BOOL isCanceled) {
//        
//        if (failure) {
//            failure(error);
//        }
//
//    }];
//}

/**
 *  Perform needed update action. It can be either update+findUsers or only findUsers.
 */
//- (void)performNeededUpdateAction
//{
//    if (self.updateNeeded) {
//        WEAK_SELF;
//        [self updateCurrentProfileOnSuccess:^{
//            weakSelf.updateNeeded = NO;
//            [weakSelf findNearestUsers];
//        } onFailure:^(NSError *error) {
//            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//            [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
//        }];
//    } else if (!self.nearestUsers.count) {
//        [self findNearestUsers];
//    }
//}

/**
 *  Find nearest users
 */
- (void)findNearestUsers
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade findNearestUsersWithPage:weakSelf.currentPage onSuccess:^(NSArray *nearestUsers) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        weakSelf.nearestUsers = [nearestUsers mutableCopy];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
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

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    FRDFriendDragableParentView *parentView;
    
    NSLog(@"self.nearestUsers.count = %d, self.swipableViewsCounter = %d", self.nearestUsers.count, self.swipableViewsCounter);
    
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
    switch (direction) {
        case ZLSwipeableViewDirectionLeft: {
            NSLog(@"User has been removed");
            break;
        }
        case ZLSwipeableViewDirectionRight: {
            NSLog(@"User has been added");
            break;
        }
        default:
            break;
    }
    
    if (self.nearestUsers.count) {
        [self.nearestUsers removeObject:self.nearestUsers.firstObject];
    }
    
    if (self.nearestUsers.count) {
        self.currentNearestUser = self.nearestUsers.firstObject;
        [self updateNearestUserInformation];
    }
    
    if (!self.nearestUsers.count) {
        self.swipableViewsCounter = 0;
        //        self.currentPage++;
        [self findNearestUsers];
    }
    
}


@end
