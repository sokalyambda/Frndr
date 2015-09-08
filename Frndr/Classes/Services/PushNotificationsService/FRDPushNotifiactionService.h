//
//  BZRPushNotifiactionServer.h
//  BizrateRewards
//
//  Created by Euginity on 17.10.14.
//  Copyright (c) 2014 Connexity. All rights reserved.
//

@interface FRDPushNotifiactionService : NSObject

+ (void)registerApplicationForPushNotifications:(UIApplication *)application;

+ (void)recivedPushNotification:(NSDictionary*)userInfo;
+ (void)saveAndSendDeviceData:(NSString *)deviceToken;

+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken;
+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error;

+ (BOOL)pushNotificationsEnabled;

@end
