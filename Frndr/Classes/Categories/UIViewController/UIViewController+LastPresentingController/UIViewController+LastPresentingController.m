//
//  UIViewController+LastPresentingController.m
//  Frndr
//
//  Created by Eugenity on 13.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "UIViewController+LastPresentingController.h"

@implementation UIViewController (LastPresentingController)

- (UIViewController *)lastPresentingController
{
    UIViewController *controller = self.presentingViewController;
    UIViewController *lastController;
    while (controller) {
        lastController = controller;
        controller = controller.presentingViewController;
    }
    return lastController;
}

@end
