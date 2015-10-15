//
//  FRDClearMessageRequest.m
//  Frndr
//
//  Created by Pavlo on 10/14/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDClearMessageRequest.h"

static NSString *kRequestAction = @"messages";
static NSString *kRequestParameterMessageId = @"id";

@interface FRDClearMessageRequest ()

@property (strong, nonatomic) NSString *requestAction;
@property (strong, nonatomic) NSString *messageId;

@end

@implementation FRDClearMessageRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return [NSString stringWithFormat:@"%@/%@", kRequestAction, self.messageId];
}

#pragma mark - Lifecycle

- (instancetype)initWithMessageId:(NSString *)messageId
{
    self = [super init];
    if (self) {
        
        _messageId = messageId;
        self.action = self.requestAction;
        _method = @"DELETE";
        
        NSMutableDictionary *parameters = [@{ } mutableCopy];
        
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
