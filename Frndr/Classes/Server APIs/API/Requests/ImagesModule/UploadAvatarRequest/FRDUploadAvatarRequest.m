//
//  FRDUploadAvatarRequest.m
//  Frndr
//
//  Created by Eugenity on 04.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDUploadAvatarRequest.h"

#import "FRDAvatar.h"

#import "UIImage+Base64Encoding.h"

static NSString *const requestAction = @"image/avatar";

static NSString *const kUserAvatar = @"image";

static NSString *const kUploadingPatternString = @"data:image/png;base64,";

@implementation FRDUploadAvatarRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        
        UIImage *avatarImage = [FRDStorageManager sharedStorage].currentUserProfile.currentAvatar.avatarImage;

        NSString *base64Avatar = [avatarImage encodeToBase64String];
        
        NSMutableDictionary *parameters = [@{kUserAvatar: [NSString stringWithFormat:@"%@ %@", kUploadingPatternString, base64Avatar]
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
