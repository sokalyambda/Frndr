//
//  FRDGetFriendProfileRequest.m
//  Frndr
//
//  Created by Eugenity on 09.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetFriendProfileRequest.h"

#import "FRDFriend.h"

static NSString *const kRequestAction = @"users/friendProfile";

@interface FRDGetFriendProfileRequest ()

@property (strong, nonatomic) NSString *requestAction;
@property (strong, nonatomic) NSString *friendId;

@end

@implementation FRDGetFriendProfileRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return [NSString stringWithFormat:@"%@/%@", kRequestAction, _friendId];
}

#pragma mark - Lifecycle

- (instancetype)initWithFriendId:(NSString *)friendId
{
    self = [super init];
    if (self) {
        
        _friendId = friendId;
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
    FRDFriend *friend = [[FRDFriend alloc] initFullFriendProfileWithServerResponse:responseObject];
    self.currentFriend = friend;
    return !!self.currentFriend;
}

@end
