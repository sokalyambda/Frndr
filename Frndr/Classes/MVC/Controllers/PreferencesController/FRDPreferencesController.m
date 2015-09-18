//
//  FRDPreferencesController.m
//  Frndr
//
//  Created by Pavlo on 9/9/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPreferencesController.h"

#import "FRDSerialViewConstructor.h"

@implementation FRDPreferencesController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *rightIcon = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:@selector(customPopViewController:)];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = rightIcon;

    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

- (IBAction)logoutFromFrndrClick:(id)sender
{
    NSLog(@"'Logout from Frndr' button clicked");
}

/**
 *  Custom pop controller
 *
 *  @param sender Sender (Can be a button)
 */
- (void)customPopViewController:(id)sender
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CATransition *transition = [CATransition animation];
    transition.duration = .4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
}

@end
