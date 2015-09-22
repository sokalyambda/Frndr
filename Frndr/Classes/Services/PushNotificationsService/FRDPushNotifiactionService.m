//
//  FRDPushNotifiactionService.m
//  BizrateRewards
//
//  Created by Eugenity on 17.10.14.
//  Copyright (c) 2014 Connexity. All rights reserved.
//

#import "FRDPushNotifiactionService.h"

@implementation FRDPushNotifiactionService

/**
 *  Called when application successfully registered for remote notifications and device token has been received
 *
 *  @param deviceToken Current Device Token
 */
+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken
{
    NSString *token = [[[deviceToken.description
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self saveAndSendDeviceData:token];
}

/**
 *  Called when application is failed to register for push notifications
 *
 *  @param error Error
 */
+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error
{

}

/**
 *  Registering application for push notifications
 *
 *  @param application Application that will be registered
 */
+ (void)registerApplicationForPushNotifications:(UIApplication *)application
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [application registerUserNotificationSettings:settings];
}

/**
 *  Checking whether application is registered for push notifications
 *
 *  @return Returns 'YES' if registered
 */
+ (BOOL)pushNotificationsEnabled
{ 
    BOOL isPushesEnabled = [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    
    return isPushesEnabled;
}

/**
 *  Called when applications received the remote notifications
 *
 *  @param userInfo Push notification info dictionary
 */
+ (void)recivedPushNotification:(NSDictionary*)userInfo
{
    
}

/**
 *  Save devicet token and send device data to server
 */
+ (void)saveAndSendDeviceData:(NSString *)deviceToken
{
    BOOL enabled = [self pushNotificationsEnabled];
    if (!enabled) {
        deviceToken = nil;
        return;
    }
    
    //save the apns token
    [FRDStorageManager sharedStorage].deviceToken = deviceToken;

}

@end
