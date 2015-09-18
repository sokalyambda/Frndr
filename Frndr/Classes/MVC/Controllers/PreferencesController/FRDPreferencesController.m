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
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 40.f;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[fixedSpace];
}

- (IBAction)logoutFromFrndrClick:(id)sender
{
    NSLog(@"'Logout from Frndr' button clicked");
}

- (void)customPopViewController:(id)sender
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    [CATransaction setCompletionBlock:^{
        NSLog(@"complete!");
    }];
    
    CATransition *transition = [CATransition animation];
    transition.duration = .4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:@"popController"];
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
}

@end
