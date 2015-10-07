//
//  FRDKeyboardResponderController.m
//  Frndr
//
//  Created by Pavlo on 10/7/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDKeyboardResponderController.h"

@interface FRDKeyboardResponderController ()

@end

@implementation FRDKeyboardResponderController 

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self subscribeForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unsubscribeFromKeyboardNotifications];
}

#pragma mark - Actions

- (void)subscribeForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification handlers

- (void)keyboardWillShow:(NSNotification*)notification
{
    // Override in subclass
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    // Override in subclass
}

@end
