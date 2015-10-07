//
//  FRDGetChatHistoryRequest.m
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetChatHistoryRequest.h"

#import "FRDChatMessage.h"

static NSString *const kRequestAction = @"messages";

@interface FRDGetChatHistoryRequest ()

@property (strong, nonatomic) NSString *friendId;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation FRDGetChatHistoryRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return [NSString stringWithFormat:@"%@/%@/%d", kRequestAction, self.friendId, self.currentPage];
}

#pragma mark - Lifecycle

- (instancetype)initWithFriendId:(NSString *)friendId andPage:(NSInteger)page
{
    self = [super init];
    if (self) {
        
        _friendId = friendId;
        _currentPage = page;
        
        self.action = [self requestAction];
        _method = @"GET";
        
        NSMutableDictionary *parameters = [@{
                                             } mutableCopy];
        
        self.serializationType = FRDRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    NSMutableArray *messages = [NSMutableArray array];
    
    for (NSDictionary *messageDict in responseObject) {
        FRDChatMessage *currentMessage = [[FRDChatMessage alloc] initWithServerResponse:messageDict];
        [messages addObject:currentMessage];
    }
    
    self.chatHistory = messages;
    
    return !!self.chatHistory;
}

@end
