//
//  FRDPushNotifiactionService.h
//  BizrateRewards
//
//  Created by Euginity on 17.10.14.
//  Copyright (c) 2014 Connexity. All rights reserved.
//

@class FRDFriend;

@interface FRDPushNotifiactionService : NSObject

+ (void)registerApplicationForPushNotifications:(UIApplication *)application;

+ (void)receivedPushNotification:(NSDictionary*)userInfo withApplicationState:(UIApplicationState)state;
+ (void)saveAndSendDeviceData:(NSString *)deviceToken;

+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken;
+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error;

+ (BOOL)pushNotificationsEnabled;

+ (void)cleanPushNotificationsBadges;

+ (void)handleActionWithIdentifier:(NSString *)identifier
             forRemoteNotification:(NSDictionary *)userInfo
                 completionHandler:(void(^)())completionHandler;
+ (void)checkForRedirectionWithCurrentFriend:(FRDFriend *)currentFriend;

@end
