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

#import "FRDFriendDragableView.h"
#import "FRDFriendDragableParentView.h"

#import "UIView+MakeFromXib.h"

#import "FRDSerialViewConstructor.h"

static NSString *const kPreferencesImageName = @"PreferencesIcon";
static NSString *const kMessagesImageName = @"MessagesIcon";

@interface FRDSearchFriendsController ()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) IBOutlet ZLSwipeableView *dragableViewsHolder;

@property (weak, nonatomic) IBOutlet UILabel *interestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UIView *photosCollectionContainer;

@end

@implementation FRDSearchFriendsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.dragableViewsHolder.dataSource = self;
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
    FRDFriendsListController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDFriendsListController class])];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)preferencesBarButtonClicked:(id)sender
{
    FRDPreferencesController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDPreferencesController class])];
    [self.navigationController pushViewController:controller animated:YES];
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

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction
{
    switch (direction) {
        case ZLSwipeableViewDirectionLeft: {
            break;
        }
        case ZLSwipeableViewDirectionRight: {
            break;
        }
        default:
            break;
    }
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view
{
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didStartSwipingView:(UIView *)view atLocation:(CGPoint)location
{
    NSLog(@"did start swiping at location: x %f, y%f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location  translation:(CGPoint)translation
{
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location
{
    NSLog(@"did start swiping at location: x %f, y%f", location.x, location.y);
}

@end
