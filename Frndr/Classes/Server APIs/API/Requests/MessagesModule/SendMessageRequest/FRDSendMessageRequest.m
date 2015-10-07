//
//  FRDSendMessageRequest.m
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSendMessageRequest.h"

static NSString *const requestAction = @"messages";

static NSString *const kFriendId = @"friendId";
static NSString *const kMessageBody = @"message";

@implementation FRDSendMessageRequest

#pragma mark - Lifecycle

- (instancetype)initWithFriendId:(NSString *)friendId andMessageBody:(NSString *)messageBody
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        
        NSMutableDictionary *parameters = [@{kFriendId: friendId,
                                             kMessageBody: messageBody
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
