//
//  FRDGetAvatarAndGalleryPhotosRequest.m
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetAvatarAndGalleryPhotosRequest.h"

#import "FRDAvatar.h"

static NSString *const requestAction = @"image/managePhotoes";

static NSString *const kAvatar = @"avatar";
static NSString *const kPhotosGallery = @"gallery";

@implementation FRDGetAvatarAndGalleryPhotosRequest

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
    self.currentAvatar = [[FRDAvatar alloc] initWithServerResponse:responseObject[kAvatar]];
    
    NSMutableArray *gallery = [NSMutableArray array];
    
    for (NSDictionary *photoDict in responseObject[kPhotosGallery]) {
        FRDGalleryPhoto *galleryPhoto = [[FRDGalleryPhoto alloc] initWithServerResponse:photoDict];
        [gallery addObject:galleryPhoto];
    }
    
    self.galleryPhotos = gallery;
    
    return !!(self.galleryPhotos && self.currentAvatar);
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
