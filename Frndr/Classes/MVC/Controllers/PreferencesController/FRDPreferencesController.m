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

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    self.navigationTitleView.titleText = LOCALIZED(@"Preferences");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *rightIcon = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:nil];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = rightIcon;
}

- (IBAction)logoutFromFrndrClick:(id)sender
{
    NSLog(@"'Logout from Frndr' button clicked");
}

#pragma mark - UIStatusBar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
