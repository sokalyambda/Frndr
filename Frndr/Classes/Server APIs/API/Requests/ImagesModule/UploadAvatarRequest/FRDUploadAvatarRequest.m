//
//  FRDUploadAvatarRequest.m
//  Frndr
//
//  Created by Eugenity on 04.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDUploadAvatarRequest.h"

static NSString *const requestAction = @"users/avatar";

static NSString *const kUserAvatar = @"avatar";

@implementation FRDUploadAvatarRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.action = [self requestAction];
        _method = @"POST";
        
        NSURL *avatarURL = [FRDStorageManager sharedStorage].currentUserProfile.avatarURL;
//        UIImage *image
        
        
        
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

- (NSString *)requestAction
{
    return requestAction;
}

@end
