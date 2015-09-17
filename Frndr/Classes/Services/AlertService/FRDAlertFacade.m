//
//  BZRAlertFacade.m
//  BizrateRewards
//
//  Created by Eugenity on 03.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDAlertFacade.h"

#import "FRDBaseNavigationController.h"

#import "AppDelegate.h"

#import "FRDErrorHandler.h"

NSString *const kErrorAlertTitle = @"AlertTitle";
NSString *const kErrorAlertMessage = @"AlertMessage";

@implementation FRDAlertFacade

#pragma mark - Actions

/**
 *  Show alert if email has already registered
 *
 *  @param error      Error that should be parsed
 *  @param completion Completion Block
 */
+ (void)showEmailAlreadyRegisteredAlertWithError:(NSError *)error forController:(UIViewController *)controller andCompletion:(void(^)(void))completion
{
    [self showFailureResponseAlertWithError:error forController:controller andCompletion:completion];
}

/**
 *  Show geolocation global alert
 *
 *  @param completion Completion Block
 */
+ (void)showGlobalGeolocationPermissionsAlertForController:(UIViewController *)controller withCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(@"Location services are off") message:LOCALIZED(@"To use background location you must turn on 'Always' in the Location Services Settings") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, YES);
        }
    }];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, NO);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    
    [self showCurrentAlertController:alertController forController:controller];
}

/**
 *  Show push notifications global alert
 *
 *  @param completion Completion Block
 */
+ (void)showGlobalPushNotificationsPermissionsAlertForController:(UIViewController *)controller withCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(@"Push-notifications are off") message:LOCALIZED(@"Do you want to enable them from settings?") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"NO") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, YES);
        }
    }];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:LOCALIZED(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, NO);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    
    [self showCurrentAlertController:alertController forController:controller];
}

/**
 *  Show retry internet connection alert
 *
 *  @param completion Completion Block
 */
+ (void)showRetryInternetConnectionAlertForController:(UIViewController *)controller withCompletion:(void(^)(BOOL retry))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Connection failed. Try again?") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"NO") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(NO);
        }
    }];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:LOCALIZED(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(YES);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:acceptAction];
    
    [self showCurrentAlertController:alertController forController:controller];
}

/**
 *  Show change permissions alert
 *
 *  @param accessType BZRAccessType
 *  @param completion Completion Block
 */
+ (void)showChangePermissionsAlertWithAccessType:(BZRAccessType)accessType forController:(UIViewController *)controller andCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion
{
    NSString *alertMessage;
    switch (accessType) {
        case BZRAccessTypeGeolocation:
            alertMessage = LOCALIZED(@"Do you want to enable/disable geolocation from settings?");
            break;
        case BZRAccessTypePushNotifications:
            alertMessage = LOCALIZED(@"Do you want to enable/disable push notifications from settings?");
            break;
        default:
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertMessage message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"NO") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, YES);
        }
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        if (completion) {
            completion(action, NO);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self showCurrentAlertController:alertController forController:controller];
}

#pragma mark - Private methods

/**
 *  Show alert controller
 *
 *  @param alertController Alert Controller that should be presented
 */
+ (void)showCurrentAlertController:(UIAlertController *)alertController forController:(UIViewController *)currentController
{
    if (!currentController) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        FRDBaseNavigationController *navigationController = (FRDBaseNavigationController *)appDelegate.window.rootViewController;
        UIViewController *lastPresentedViewController = ((UIViewController *)navigationController.viewControllers.lastObject).presentedViewController;
        
        if (lastPresentedViewController) {
            [lastPresentedViewController presentViewController:alertController animated:YES completion:nil];
        } else {
            [navigationController presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        [currentController presentViewController:alertController animated:YES completion:nil];
    }
    
}

#pragma mark - Alerts

/**
 *  Show error alert with title and message
 *
 *  @param title      Alert Title
 *  @param error      Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithTitle:(NSString *)title andError:(NSError *)error forController:(UIViewController *)controller withCompletion:(void(^)(void))completion
{
    if (!error) {
        return;
    }
    
    NSMutableString *errStr = [NSMutableString stringWithString: LOCALIZED(@"Error")];

    [errStr appendFormat:@"\n%@", error.localizedDescription];
    
    if (error.localizedFailureReason)
        [errStr appendFormat:@"\n%@", error.localizedFailureReason];
    
    if (error.localizedRecoverySuggestion)
        [errStr appendFormat:@"\n%@", error.localizedRecoverySuggestion];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(title) message:errStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LOCALIZED(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion();
        }
    }];
    
    [alertController addAction:okAction];
    [self showCurrentAlertController:alertController forController:controller];
}

/**
 *  Show alert with error
 *
 *  @param error      Error that should be parsed
 *  @param completion Completion Block
 */
+ (void)showErrorAlert:(NSError *)error forController:(UIViewController *)controller withCompletion:(void(^)(void))completion
{
    [self showAlertWithTitle:@"" andError:error forController:controller withCompletion:completion];
}

/**
 *  Show alert with title and message
 *
 *  @param title      Alert Title
 *  @param message    Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message forController:(UIViewController *)currentController withCompletion:(void(^)(void))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LOCALIZED(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion();
        }
    }];
    
    [alertController addAction:okAction];
    [self showCurrentAlertController:alertController forController:currentController];
}

/**
 *  Show Alert with message
 *
 *  @param message    Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithMessage:(NSString *)message forController:(UIViewController *)controller withCompletion:(void(^)(void))completion
{
    [self showAlertWithTitle:@"" andMessage:message forController:controller withCompletion:completion];
}

/**
 *  Show response error alert
 *
 *  @param error      Error that shoud be parsed
 *  @param completion Completion Block
 */
+ (void)showFailureResponseAlertWithError:(NSError *)error forController:(UIViewController *)controller andCompletion:(void(^)(void))completion
{
    if (!error) {
        return;
    }
    
    WEAK_SELF;
    [FRDErrorHandler parseError:error withCompletion:^(NSString *alertTitle, NSString *alertMessage) {
        [weakSelf showAlertWithTitle:alertTitle andMessage:alertMessage forController:controller withCompletion:completion];
    }];
}

/**
 *  Show dialog alert with completion and two buttons (ok and cancel)
 *
 *  @param message    Message for alert
 *  @param controller Presenting controller
 *  @param completion Completion Block
 */
+ (void)showDialogAlertWithMessage:(NSString *)message forController:(UIViewController *)controller withCompletion:(void(^)(BOOL cancel))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LOCALIZED(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(NO);
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(YES);
        }
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self showCurrentAlertController:alertController forController:controller];
}

@end
