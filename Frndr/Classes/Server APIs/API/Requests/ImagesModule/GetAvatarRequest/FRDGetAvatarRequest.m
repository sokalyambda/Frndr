//
//  FRDGetAvatarRequest.m
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetAvatarRequest.h"

#import "FRDAvatar.h"

static NSString *const kRequestAction = @"image/avatar";

static NSString *const kAvatar = @"avatar";
static NSString *const kPhotosGallery = @"gallery";

@interface FRDGetAvatarRequest ()

@property (strong, nonatomic) NSString *requestAction;
@property (assign, nonatomic) BOOL small;

@end

@implementation FRDGetAvatarRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return self.small ? [NSString stringWithFormat:@"%@/small", kRequestAction] : kRequestAction;
}

#pragma mark - Lifecycle

- (instancetype)initWithSmall:(BOOL)small
{
    self = [super init];
    if (self) {
        _small = small;
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
    self.currentAvatar = [[FRDAvatar alloc] initWithServerResponse:responseObject[kAvatar]];
    
    return !!(self.currentAvatar);
}

@end
