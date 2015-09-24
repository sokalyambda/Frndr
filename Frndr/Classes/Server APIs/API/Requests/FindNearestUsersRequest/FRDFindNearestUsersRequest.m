//
//  FRDFindNearestUsersRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFindNearestUsersRequest.h"

#import "FRDNearestUser.h"

static NSString *const kRequestAction = @"users/find";

@interface FRDFindNearestUsersRequest ()

@property (nonatomic) NSString *requestAction;
@property (nonatomic) NSInteger currentPage;

@end

@implementation FRDFindNearestUsersRequest

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
        
        self.action = self.requestAction;
        _method = @"GET";
        
        NSMutableDictionary *parameters = [@{} mutableCopy];
        
        self.serializationType = FRDRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

#pragma mark - Actions

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    @autoreleasepool {
        
        NSMutableArray *nearestUsers = [NSMutableArray array];
        for (NSDictionary *responseDict in responseObject) {
            FRDNearestUser *currentNearestUser = [[FRDNearestUser alloc] initWithServerResponse:responseDict];
            @synchronized(self) {
                [nearestUsers addObject:currentNearestUser];
            }
        }
        
        self.nearestUsers = nearestUsers;
        
    }

    return !!self.nearestUsers;
}

@end
