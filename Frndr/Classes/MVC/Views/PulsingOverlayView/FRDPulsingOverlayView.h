//
//  FRDPulsingOverlayView.h
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@interface FRDPulsingOverlayView : UIView

- (void)showInView:(UIView *)view withProfile:(FRDCurrentUserProfile *)profile;
- (void)dismissFromView:(UIView *)view;

- (void)addPulsingAnimationsWithProfile:(FRDCurrentUserProfile *)profile;

@end
