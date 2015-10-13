//
//  FRDBlockFriendRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBlockFriendRequest.h"

#import "FRDFriend.h"

static NSString *const kRequestAction = @"users/blockFriend";

@interface FRDBlockFriendRequest ()

@property (strong, nonatomic) NSString *friendId;
@property (strong, nonatomic) NSString *requestAction;

@end

@implementation FRDBlockFriendRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return [NSString stringWithFormat:@"%@/%@", kRequestAction, self.friendId];
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
    return !!responseObject;
}

@end
