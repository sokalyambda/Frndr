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

#import "FRDSerialViewConstructor.h"

static NSString *const kPreferencesImageName = @"PreferencesIcon";
static NSString *const kMessagesImageName = @"MessagesIcon";

static NSString *const kPreferencesSegueIdentifier = @"preferencesSegueIdentifier";
static NSString *const kFriendsListSegueIdentifier = @"friendsListSegueIdentifier";

@interface FRDSearchFriendsController ()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) IBOutlet ZLSwipeableView *dragableViewsHolder;

@property (weak, nonatomic) IBOutlet UILabel *interestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UIView *photosCollectionContainer;

@property (nonatomic) FRDPreviewGalleryController *previewGalleryController;

@end

@implementation FRDSearchFriendsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPhotosGalleryContainer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupDragableViewOptions];
    });
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
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *preferencesBarButton = [FRDSerialViewConstructor customBarButtonWithImage:[UIImage imageNamed:kPreferencesImageName] forController:self withAction:@selector(preferencesBarButtonClicked:)];
    self.navigationItem.leftBarButtonItem = preferencesBarButton;

    UIBarButtonItem *messagesBarButton = [FRDSerialViewConstructor customBarButtonWithImage:[UIImage imageNamed:kMessagesImageName] forController:self withAction:@selector(messagesBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = messagesBarButton;
}

- (void)messagesBarButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:kFriendsListSegueIdentifier sender:self];
}

- (void)preferencesBarButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:kPreferencesSegueIdentifier sender:self];
}

- (void)setupPhotosGalleryContainer
{
    self.previewGalleryController = [[FRDPreviewGalleryController alloc] initWithNibName:NSStringFromClass([FRDPreviewGalleryController class]) bundle:nil];
    [self.previewGalleryController.view setFrame:self.photosCollectionContainer.frame];
    [self.photosCollectionContainer addSubview:self.previewGalleryController.view];
    [self addChildViewController:self.previewGalleryController];
    [self.previewGalleryController didMoveToParentViewController:self];
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
    FRDFriendDragableParentView *parentView = [[FRDFriendDragableParentView alloc] initWithFrame:swipeableView.bounds];

    FRDFriendDragableView *friendView = [FRDFriendDragableView makeFromXib];
    friendView.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addSubview:friendView];
    [self addConstraintsForParentView:parentView andContentView:friendView];

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

- (void)swipeableView:(ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location  translation:(CGPoint)translation
{

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location
{

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPreferencesSegueIdentifier]) {
        FRDPreferencesController *controller = (FRDPreferencesController *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:kFriendsListSegueIdentifier]) {
        FRDFriendsListController *controller = (FRDFriendsListController *)segue.destinationViewController;
    }
}

@end
