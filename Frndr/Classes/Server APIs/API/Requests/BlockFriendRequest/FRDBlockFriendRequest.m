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

@property (strong, nonatomic) FRDFriend *currentFriend;
@property (strong, nonatomic) NSString *requestAction;

@end

@implementation FRDBlockFriendRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return [NSString stringWithFormat:@"%@/%@", kRequestAction, self.currentFriend.userId];
}

#pragma mark - Lifecycle

- (instancetype)initWithFriend:(FRDFriend *)currentFriend
{
    self = [super init];
    if (self) {
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
