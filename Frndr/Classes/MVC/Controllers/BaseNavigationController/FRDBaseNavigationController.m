//
//  FDRBaseNavigationController.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseNavigationController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDProjectFacade.h"

@interface FRDBaseNavigationController ()

@end

@implementation FRDBaseNavigationController

#pragma mark - Accessors

- (UIBarButtonItem *)customBackButton
{
    if (!_customBackButton) {
        _customBackButton = [FRDSerialViewConstructor backButtonForController:self withAction:@selector(backClick:)];
    }
    return _customBackButton;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationBar];
}

#pragma mark - Actions

/**
 *  Customize navigation bar
 */
- (void)customizeNavigationBar
{
    self.navigationBar.translucent = NO;
    
    //Remove separator under navigation bar
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    /*
    [self.navigationBar setBarTintColor:UIColorFromRGB(0x12a9d6)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:20.f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
     */
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

/**
 *  Custom back action
 *
 *  @param sender Back button
 */
- (void)backClick:(UIBarButtonItem *)sender
{
    if ([FRDProjectFacade isOperationInProcess]) {
        return;
    }
    [self popViewControllerAnimated:YES];
}

@end
