//
//  FRDLikeUserByIdRequest.m
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDLikeUserByIdRequest.h"

static NSString *const kRequestAction = @"users/like";

@interface FRDLikeUserByIdRequest ()

@property (strong, nonatomic) NSString *requestAction;

@end

@implementation FRDLikeUserByIdRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return [NSString stringWithFormat:@"%@/%@", kRequestAction, self.currentUserId];
}

#pragma mark - Lifecycle

- (instancetype)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _currentUserId = userId;
        
        self.action = self.requestAction;
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
    return !!responseObject;
}

@end
