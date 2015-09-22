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
static NSString *const kPushToken = @"pushToken";
static NSString *const kOSVersion = @"os";
static NSString *const kGeolocationCoordinates = @"coordinates";

static NSString *const kOSVersionApple = @"APPLE";

@implementation FRDSignInWithFacebookRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        
        NSString *fbAccessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:FBAccessToken];
        CLLocation *currentLocaion = [FRDLocationObserver sharedObserver].currentLocation;
        NSArray *coords = @[@(currentLocaion.coordinate.longitude), @(currentLocaion.coordinate.latitude)];
        
        NSMutableDictionary *parameters;
        if (fbAccessTokenString) {
            parameters = [NSMutableDictionary dictionaryWithDictionary:@{kFacebookAccessToken: fbAccessTokenString,
                                                                         kOSVersion: kOSVersionApple,
                                                                         kGeolocationCoordinates: coords,
                                                                         kPushToken: @"wefewfrg43rr3fc5tv44s5by"
                                                                         }];
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
