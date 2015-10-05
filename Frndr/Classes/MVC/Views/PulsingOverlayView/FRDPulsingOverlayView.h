//
//  FRDPulsingOverlayView.h
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@interface FRDPulsingOverlayView : UIView

- (void)showHide;

- (void)showInView:(UIView *)view;
- (void)dismissFromView:(UIView *)view;

- (void)addPulsingAnimations;

- (void)subscribeForNotifications;
- (void)unsibscribeFromNotifications;

@end
