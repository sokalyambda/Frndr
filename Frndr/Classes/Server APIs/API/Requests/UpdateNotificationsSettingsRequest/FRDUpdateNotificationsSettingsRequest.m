//
//  FRDUpdateNotificationsSettingsRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDUpdateNotificationsSettingsRequest.h"

static NSString *const requestAction = @"users/notifications";

static NSString *const kNewFriendsNotification = @"newFriends";
static NSString *const kNewMessagesNotification = @"newMessages";

@implementation FRDUpdateNotificationsSettingsRequest

#pragma mark - Lifecycle

- (instancetype)initWithFriendsNotificationsEnabled:(BOOL)friendNotificationsEnabled andMessagesNotificationsEnabled:(BOOL)messagesNotificationEnabled
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"PUT";
        
        NSMutableDictionary *parameters = [@{
                                             kNewFriendsNotification: @(friendNotificationsEnabled),
                                             kNewMessagesNotification: @(messagesNotificationEnabled)
                                             } mutableCopy];
        
        self.serializationType = FRDRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    return !!responseObject;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
