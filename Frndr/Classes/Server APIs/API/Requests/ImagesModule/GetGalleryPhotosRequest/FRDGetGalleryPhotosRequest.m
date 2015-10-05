//
//  FRDGetGalleryPhotosRequest.m
//  Frndr
//
//  Created by Eugenity on 04.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetGalleryPhotosRequest.h"

#import "FRDGalleryPhoto.h"

static NSString *const requestAction = @"image/photo";

static NSString *const kPhotosGallery = @"urls";

@implementation FRDGetGalleryPhotosRequest

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
    NSMutableArray *gallery = [NSMutableArray array];
    
    for (NSDictionary *photoDict in responseObject[kPhotosGallery]) {
        FRDGalleryPhoto *photo = [[FRDGalleryPhoto alloc] initWithServerResponse:photoDict];
        [gallery addObject:photo];
    }
    
    self.galleryPhotos = gallery;
    
    return !!self.galleryPhotos;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
