//
//  FRDFriend.m
//  Frndr
//
//  Created by Eugenity on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriend.h"

#import "FRDCommonDateFormatter.h"

#import "ISO8601DateFormatter.h"

static NSString *const kNewFriend = @"newFriend";
static NSString *const kLastMessage = @"message";
static NSString *const kFriendId = @"friendId";
static NSString *const kLastMessagePostedDate = @"date";

@implementation FRDFriend

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super initWithServerResponse:response];
    if (self) {
        _userId = response[kFriendId];
        _newFriend = [response[kNewFriend] boolValue];
        _lastMessage = response[kLastMessage];
        _lastMessagePostedDate = [[FRDCommonDateFormatter commonISO8601DateFormatter] dateFromString:response[kLastMessagePostedDate]];
    }
    return self;
}

@end
