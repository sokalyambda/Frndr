//
//  FRDFindNearestUsersRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFindNearestUsersRequest.h"

static NSString *const requestAction = @"users/find/1";

@implementation FRDFindNearestUsersRequest

#pragma mark - Lifecycle

- (instancetype)initWithPage:(NSInteger)page
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
    NSLog(@"response %@", responseObject);
    return !!responseObject;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
