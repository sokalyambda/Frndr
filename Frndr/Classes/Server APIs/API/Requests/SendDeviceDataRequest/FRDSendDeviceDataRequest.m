//
//  FRDSendDeviceDataRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSendDeviceDataRequest.h"

static NSString *const requestAction = @"users/pushToken";

static NSString *const kPushToken = @"pushToken";
static NSString *const kOSVersion = @"os";
static NSString *const kDeviceID = @"deviceId";

static NSString *const kAppleOSVersion = @"APPLE";

@implementation FRDSendDeviceDataRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        
        _retryIfConnectionFailed = NO;
        
        NSString *pushToken = [FRDStorageManager sharedStorage].deviceToken;
        NSString *deviceID = [FRDStorageManager sharedStorage].deviceUDID;
        
        NSMutableDictionary *parameters;
        if (pushToken.length) {
            parameters = [@{kPushToken: pushToken,
                            kOSVersion: kAppleOSVersion,
                            kDeviceID: deviceID
                            } mutableCopy];
        }
        
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
