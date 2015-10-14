//
//  FRDNoMatchesView.h
//  Frndr
//
//  Created by Eugenity on 14.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@protocol FRDNoMatchesViewDelegate;

@interface FRDNoMatchesView : UIView

@property (weak, nonatomic) id<FRDNoMatchesViewDelegate> delegate;

@end

@protocol FRDNoMatchesViewDelegate <NSObject>

@optional
- (void)noMatchesViewShouldShowSearchNearestUsersController:(FRDNoMatchesView *)view;

@end
