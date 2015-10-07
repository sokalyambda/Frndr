//
//  FRDGetFriendsListRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetFriendsListRequest.h"

#import "FRDFriend.h"

static NSString *const kRequestAction = @"users/friendList";

@interface FRDGetFriendsListRequest ()

@property (strong, nonatomic) NSString *requestAction;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation FRDGetFriendsListRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return [NSString stringWithFormat:@"%@/%d", kRequestAction, self.currentPage];
}

#pragma mark - Lifecycle

- (instancetype)initWithPage:(NSInteger)page
{
    self = [super init];
    if (self) {
        
        _currentPage = page;
        
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
    NSMutableArray *friends = [@[] mutableCopy];
    for (NSDictionary *response in responseObject) {
        FRDFriend *currentFriend = [[FRDFriend alloc] initWithServerResponse:response];
        [friends addObject:currentFriend];
    }
    self.friendsList = [NSMutableArray arrayWithArray:friends];
    return !!self.friendsList;
}

@end
