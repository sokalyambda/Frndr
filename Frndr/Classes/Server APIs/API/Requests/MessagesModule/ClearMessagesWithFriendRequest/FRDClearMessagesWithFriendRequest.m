//
//  FRDClearMessagesWithFriendRequest.m
//  Frndr
//
//  Created by Eugenity on 13.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDClearMessagesWithFriendRequest.h"

static NSString *const kRequestAction = @"messages";

static NSString *const kFriendId = @"friendId";

@interface FRDClearMessagesWithFriendRequest ()

@property (strong, nonatomic) NSString *requestAction;

@end

@implementation FRDClearMessagesWithFriendRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return kRequestAction;
}

#pragma mark - Lifecycle

- (instancetype)initWithFriendId:(NSString *)friendId
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"DELETE";
        
        NSMutableDictionary *parameters = [@{kFriendId: friendId} mutableCopy];
        
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
