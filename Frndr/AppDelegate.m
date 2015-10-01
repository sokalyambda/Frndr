//
//  AppDelegate.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "AppDelegate.h"

#import "FRDPushNotifiactionService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set flag for needed updating
    [FRDStorageManager sharedStorage].userProfileUpdateNeeded = YES;
    [FRDStorageManager sharedStorage].searchSettingsUpdateNeeded = YES;
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FRDPushNotifiactionService cleanPushNotificationsBadges];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [FRDPushNotifiactionService cleanPushNotificationsBadges];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    } else {
        [FRDPushNotifiactionService failedToRegisterForPushNotificationsWithError:nil];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [FRDPushNotifiactionService registeredForPushNotificationsWithToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [FRDPushNotifiactionService failedToRegisterForPushNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [FRDPushNotifiactionService recivedPushNotification:userInfo];
}

@end
