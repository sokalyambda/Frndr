//
//  FRDGetUserByIdRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetUserByIdRequest.h"

static NSString *const kRequestAction = @"users";

@interface FRDGetUserByIdRequest ()

@property (strong, nonatomic) NSString *requestAction;
@property (strong, nonatomic) NSString *userId;

@end

@implementation FRDGetUserByIdRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return _userId.length ? [NSString stringWithFormat:@"%@/%@", kRequestAction, _userId] : kRequestAction;
}

#pragma mark - Lifecycle

- (instancetype)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        
        _userId = userId;
        self.action = [self requestAction];
        _method = @"GET";
        
        NSMutableDictionary *parameters = [@{} mutableCopy];
        
        self.serializationType = FRDRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    FRDCurrentUserProfile *profile = [[FRDCurrentUserProfile alloc] initWithServerResponse:responseObject];
    self.userProfile = profile;
    return !!self.userProfile;
}

@end
