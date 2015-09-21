//
//  FRDPreferencesController.m
//  Frndr
//
//  Created by Pavlo on 9/9/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPreferencesController.h"

#import "FRDTopContentView.h"

@implementation FRDPreferencesController

#pragma mark - Accessors

- (NSString *)titleString
{
    return @"Preferences";
}

- (NSString *)leftImageName
{
    return nil;
}

- (NSString *)rightImageName
{
    return @"preferencesTopIcon";
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
