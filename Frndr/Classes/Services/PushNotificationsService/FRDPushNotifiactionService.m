//
//  FRDPushNotifiactionService.m
//  BizrateRewards
//
//  Created by Eugenity on 17.10.14.
//  Copyright (c) 2014 Connexity. All rights reserved.
//

#import "FRDPushNotifiactionService.h"
#import "FRDProjectFacade.h"

static NSString *const kNewMessageCategory = @"newMessageCategory";
static NSString *const kNewFriendCategory = @"newFriendCategory";

static NSString *const kReadMessageActionIdentifier = @"readMessageActionIdentifier";

static NSString *const kShowChatWithNewFriendActionIdentifier = @"showChatWithNewFriendActionIdentifier";

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
                                                                                         |UIUserNotificationTypeAlert) categories:[self notificationCategories]];
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
    NSLog(@"user info %@", userInfo);
}

/**
 *  Save device token and send device data to server
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
    
    if ([FRDStorageManager sharedStorage].deviceToken) {
        [FRDProjectFacade sendDeviceDataOnSuccess:^(BOOL isSuccess) {

        } onFailure:^(NSError *error, BOOL isCanceled) {
            [FRDAlertFacade showFailureResponseAlertWithError:error forController:nil andCompletion:nil];

        }];
    }
}

+ (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:kReadMessageActionIdentifier]) {
        NSLog(@"read message");
    } else if ([identifier isEqualToString:kShowChatWithNewFriendActionIdentifier]) {
        NSLog(@"show chat with new friend");
    }
    
    if (completionHandler) {
        completionHandler();
    }
}

/**
 *  Clean notifications badges
 */
+ (void)cleanPushNotificationsBadges
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

/**
 *  Configure notification categories
 *
 *  @return NSSet with current categories
 */
+ (NSSet *)notificationCategories
{
    UIMutableUserNotificationAction *readMessageAction = [[UIMutableUserNotificationAction alloc] init];
    [readMessageAction setActivationMode:UIUserNotificationActivationModeBackground];
    [readMessageAction setTitle:LOCALIZED(@"Read")];
    [readMessageAction setIdentifier:kReadMessageActionIdentifier];
    [readMessageAction setDestructive:NO];
    [readMessageAction setAuthenticationRequired:NO];
    
    UIMutableUserNotificationAction *showChatWithNewFriendAction = [[UIMutableUserNotificationAction alloc] init];
    [showChatWithNewFriendAction setActivationMode:UIUserNotificationActivationModeBackground];
    [showChatWithNewFriendAction setTitle:LOCALIZED(@"Open Chat")];
    [showChatWithNewFriendAction setIdentifier:kShowChatWithNewFriendActionIdentifier];
    [showChatWithNewFriendAction setDestructive:NO];
    [showChatWithNewFriendAction setAuthenticationRequired:NO];
    
    UIMutableUserNotificationCategory *newMessageCategory = [[UIMutableUserNotificationCategory alloc] init];
    [newMessageCategory setIdentifier:kNewMessageCategory];
    [newMessageCategory setActions:@[readMessageAction]
                        forContext:UIUserNotificationActionContextDefault];
    
    UIMutableUserNotificationCategory *newFriendCategory = [[UIMutableUserNotificationCategory alloc] init];
    [newFriendCategory setIdentifier:kNewFriendCategory];
    [newFriendCategory setActions:@[showChatWithNewFriendAction]
                       forContext:UIUserNotificationActionContextDefault];
    
    return [NSSet setWithObjects:newMessageCategory, newFriendCategory, nil];
}

@end
