//
//  FRDFriendDragableView.h
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "ZLSwipeableView.h"

@class FRDNearestUser;

@interface FRDFriendDragableView : UIView

@property (weak, nonatomic) IBOutlet UIView *overlayView; //dark overlay while swiping
@property (weak, nonatomic) IBOutlet UIImageView *overlayImageView; // center image view (accept or decline)
@property (weak, nonatomic) IBOutlet UIView *stackViewsBackgroundOverlay; // background color overlay view for views in stack

@property (strong, nonatomic) NSString *overlayImageName;

- (void)configureWithNearestUser:(FRDNearestUser *)nearestUser;

@end
