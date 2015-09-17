//
//  FRDSearchFriendsController.m
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSearchFriendsController.h"

#import "FRDFriendDragableView.h"

#import "UIView+MakeFromXib.h"

@interface FRDSearchFriendsController ()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) IBOutlet ZLSwipeableView *dragableViewsHolder;

@end

@implementation FRDSearchFriendsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.dragableViewsHolder.dataSource = self;
}


#pragma mark - Actions

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    UIView *parentView = [[UIView alloc] initWithFrame:swipeableView.bounds];

    FRDFriendDragableView *friendView = [FRDFriendDragableView makeFromXib];
    friendView.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addSubview:friendView];
    
    parentView.layer.shadowColor = [UIColor blackColor].CGColor;
    parentView.layer.shadowOpacity = 0.25f;
    parentView.layer.shadowOffset = CGSizeMake(0, 2.5);
    parentView.layer.shadowRadius = 10.0;
    parentView.layer.shouldRasterize = YES;
    parentView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Corner Radius
    parentView.layer.cornerRadius = 10.0;
    NSDictionary *metrics = @{
                              @"height" : @(parentView.bounds.size.height),
                              @"width" : @(parentView.bounds.size.width)
                              };
    NSDictionary *views = NSDictionaryOfVariableBindings(friendView);
    [parentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[friendView(width)]"
      options:0
      metrics:metrics
      views:views]];
    [parentView addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:
                          @"V:|[friendView(height)]"
                          options:0
                          metrics:metrics
                          views:views]];

    return parentView;
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction
{
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
