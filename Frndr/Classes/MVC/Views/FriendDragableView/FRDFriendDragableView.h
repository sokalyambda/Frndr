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

@property (weak, nonatomic) IBOutlet UIView *overlayView;

@property (strong, nonatomic) NSString *overlayImageName;

- (void)configureWithNearestUser:(FRDNearestUser *)nearestUser;

@end
