//
//  FRDPreferencesController.m
//  Frndr
//
//  Created by Pavlo on 9/9/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPreferencesController.h"

#import "FRDTopContentView.h"

#import "FRDProjectFacade.h"

@implementation FRDPreferencesController

#pragma mark - Accessors

- (NSString *)titleString
{
    return @"Preferences";
}

- (NSString *)leftImageName
{
    return @"";
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
    [self showSignOutActionSheet];
}

/**
 *  Show sign out action sheet
 */
- (void)showSignOutActionSheet
{
    UIAlertController *signOutController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Do you want to sign out?") preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *signOutAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Logout") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf signOut];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [signOutController addAction:signOutAction];
    [signOutController addAction:cancelAction];
    
    [self presentViewController:signOutController animated:YES completion:nil];
}

/**
 *  Sign out
 */
- (void)signOut
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade signOutOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

@end
