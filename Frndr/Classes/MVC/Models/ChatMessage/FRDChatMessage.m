//
//  FRDChatMessage.m
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatMessage.h"

#import "FRDCommonDateFormatter.h"
#import "ISO8601DateFormatter.h"

#import "FRDChatMessagesService.h"

//from response
static NSString *const kMessageId       = @"_id";
static NSString *const kOwner           = @"owner";
static NSString *const kMessageBody     = @"text";
static NSString *const kCreationDate    = @"date";

//from socket
static NSString *const kMessageIdSocket = @"messageId";
static NSString *const kOwnerId         = @"ownerId";
static NSString *const kCompanionId     = @"friendId";
static NSString *const kMessageText     = @"message";

@implementation FRDChatMessage

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _messageId = response[kMessageId];
        _ownerId = response[kOwner];
        _messageBody = response[kMessageBody];
        _creationDate = [[FRDCommonDateFormatter commonISO8601DateFormatter] dateFromString:response[kCreationDate]];
        
        _ownerType = [FRDChatMessagesService ownerTypeForMessage:self];
    }
    return self;
}

#pragma mark - Lifecycle

- (instancetype)initWithSocketRespose:(NSDictionary *)socketResponse
{
    self = [super init];
    if (self) {
        _ownerId = socketResponse[kOwnerId];
        _companionId = socketResponse[kCompanionId];
        _messageBody = socketResponse[kMessageText];
        _messageId = socketResponse[kMessageIdSocket];
        
        _ownerType = [FRDChatMessagesService ownerTypeForMessage:self];
    }
    return self;
}

@end
