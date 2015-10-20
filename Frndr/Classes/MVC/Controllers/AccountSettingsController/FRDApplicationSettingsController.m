//
//  FRDAccountSettingsController.m
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDApplicationSettingsController.h"

#import "FRDSerialViewConstructor.h"

@interface FRDApplicationSettingsController ()

@end

@implementation FRDApplicationSettingsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationTitleView.titleText = LOCALIZED(@"Settings");
    
    UIBarButtonItem *rightIcon = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:nil];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = rightIcon;
}

@end
