//
//  FRDGetSearchSettingsRequest.m
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetSearchSettingsRequest.h"

#import "FRDSearchSettings.h"

static NSString *const requestAction = @"users/searchSettings";

@implementation FRDGetSearchSettingsRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
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
    FRDSearchSettings *searchSettings = [[FRDSearchSettings alloc] initWithServerResponse:responseObject];
    self.currentSearchSettings = searchSettings;
    return !!self.currentSearchSettings;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
