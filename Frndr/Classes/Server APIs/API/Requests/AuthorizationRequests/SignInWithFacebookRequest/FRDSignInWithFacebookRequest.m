//
//  FRDSignInWithFacebookRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSignInWithFacebookRequest.h"

#import "FRDLocationObserver.h"

static NSString *const requestAction = @"signIn";

static NSString *const kFacebookAccessToken = @"fbId";
static NSString *const kGeolocationCoordinates = @"coordinates";

static NSString *const kAvatarExists = @"haveAvatar";
static NSString *const kUserId = @"userId";
static NSString *const kFirstLogin = @"firstLogin";

@implementation FRDSignInWithFacebookRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        
        long long facebookId = [FRDStorageManager sharedStorage].currentFacebookProfile.facebookUserId;
        CLLocation *currentLocaion = [FRDLocationObserver sharedObserver].currentLocation;
        NSArray *coords = @[@(currentLocaion.coordinate.longitude), @(currentLocaion.coordinate.latitude)];
        
        NSMutableDictionary *parameters;
        parameters = [NSMutableDictionary dictionaryWithDictionary:@{kFacebookAccessToken: @(facebookId),
                                                                     kGeolocationCoordinates: coords
                                                                     }];
        
        self.serializationType = FRDRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    self.avatarExists = [responseObject[kAvatarExists] boolValue];
    self.userId = responseObject[kUserId];
    self.firstLogin = [responseObject[kFirstLogin] boolValue];
    return !!self.userId;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
