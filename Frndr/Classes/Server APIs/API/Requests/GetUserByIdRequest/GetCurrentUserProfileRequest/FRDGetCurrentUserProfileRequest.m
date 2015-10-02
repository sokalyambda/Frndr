//
//  FRDGetCurrentUserProfileRequest.m
//  Frndr
//
//  Created by Eugenity on 26.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetCurrentUserProfileRequest.h"

#import "FRDCurrentUserProfile.h"

@implementation FRDGetCurrentUserProfileRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super initWithUserId:@""];
    if (self) {
        
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    FRDCurrentUserProfile *profile = [FRDStorageManager sharedStorage].currentUserProfile;
    [profile updateWithServerResponse:responseObject];
    
    return !!responseObject;
}

@end
