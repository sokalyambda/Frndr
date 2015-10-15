//
//  FRDPushNotifiactionService.m
//  BizrateRewards
//
//  Created by Eugenity on 17.10.14.
//  Copyright (c) 2014 Connexity. All rights reserved.
//

#import "FRDPushNotifiactionService.h"

#import "FRDProjectFacade.h"

#import "FRDRedirectionHelper.h"

#import "FRDFriend.h"
#import "FRDRemoteNotification.h"

#import "FRDBaseNavigationController.h"
#import "FRDChatController.h"

static NSString *const kNewMessageCategory = @"newMessageCategory";
static NSString *const kNewFriendCategory = @"newFriendCategory";

static NSString *const kReadMessageActionIdentifier = @"readMessageActionIdentifier";
static NSString *const kShowChatWithNewFriendActionIdentifier = @"showChatWithNewFriendActionIdentifier";

static NSString *const kAPS = @"aps";
static NSString *const kCategory = @"category";

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
+ (void)receivedPushNotification:(NSDictionary*)userInfo withApplicationState:(UIApplicationState)state
{
    //do nothing if we are already in chat
    FRDBaseNavigationController *baseNavigationController = (FRDBaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    BOOL chatExists = NO;
    for (FRDBaseViewController *controller in baseNavigationController.viewControllers) {
        if ([controller isKindOfClass:[FRDChatController class]]) {
            chatExists = YES;
            break;
        }
    }
    if ([baseNavigationController.topViewController isKindOfClass:[FRDChatController class]] || ![FRDProjectFacade isFacebookSessionValid] || chatExists) {
        return;
    }

    //redirect to chat with friend with id userInfo[friendId]
    NSDictionary *aps = userInfo[kAPS];
    NSString *pushCategory = aps[kCategory];
    
    FRDRemoteNotificationType currentNotificationType = [pushCategory isEqualToString:kNewFriendCategory] ? FRDRemoteNotificationTypeNewFriend : FRDRemoteNotificationTypeNewMessage;
    
    FRDFriend *currentFriend = [[FRDFriend alloc] initWithPushNotificationUserInfo:userInfo];
    
    NSString *alertTitle = currentNotificationType == FRDRemoteNotificationTypeNewFriend ?
    [NSString localizedStringWithFormat:@"%@ %@. %@", LOCALIZED(@"You have new friend -"), currentFriend.fullName, LOCALIZED(@"Do you want to open chat with him?")] :
    [NSString localizedStringWithFormat:@"%@ %@. %@", LOCALIZED(@"You have new message from "), currentFriend.fullName, LOCALIZED(@"Do you want to open chat with him?")];
    
    if (state == UIApplicationStateActive) {
        // app was already in the foreground
        WEAK_SELF;
        [FRDAlertFacade showDialogAlertWithMessage:alertTitle forController:nil withCompletion:^(BOOL cancel) {
            if (!cancel) {
                [weakSelf checkForRedirectionWithCurrentFriend:currentFriend];
            }
        }];
    } else {
        [self checkForRedirectionWithCurrentFriend:currentFriend];
    }
}

+ (void)checkForRedirectionWithCurrentFriend:(FRDFriend *)currentFriend
{
    if ([FRDStorageManager sharedStorage].logined) {

        [FRDRedirectionHelper redirectToChatWithFriend:currentFriend onSuccess:^(BOOL isSuccess) {
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            
        }];
        
    } else if ([FRDProjectFacade isFacebookSessionValid]) {

        //save remote notification
        FRDRemoteNotification *remoteNotification = [[FRDRemoteNotification alloc] init];
        remoteNotification.currentFriend = currentFriend;
        [FRDStorageManager sharedStorage].remoteNoification = remoteNotification;
        
    }
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
    if ([FRDProjectFacade isFacebookSessionValid]) {
        FRDFriend *currentFriend = [[FRDFriend alloc] initWithPushNotificationUserInfo:userInfo];
        [self checkForRedirectionWithCurrentFriend:currentFriend];
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
    [readMessageAction setActivationMode:UIUserNotificationActivationModeForeground];
    [readMessageAction setTitle:LOCALIZED(@"Read")];
    [readMessageAction setIdentifier:kReadMessageActionIdentifier];
    [readMessageAction setDestructive:NO];
    [readMessageAction setAuthenticationRequired:NO];
    
    UIMutableUserNotificationAction *showChatWithNewFriendAction = [[UIMutableUserNotificationAction alloc] init];
    [showChatWithNewFriendAction setActivationMode:UIUserNotificationActivationModeForeground];
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
