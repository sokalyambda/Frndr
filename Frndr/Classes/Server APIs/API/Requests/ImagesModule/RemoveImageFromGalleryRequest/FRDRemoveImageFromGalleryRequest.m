//
//  FRDRemoveImageFromGalleryRequest.m
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRemoveImageFromGalleryRequest.h"

#import "FRDGalleryPhoto.h"

static NSString *const requestAction = @"image/photo";

static NSString *const kImageName = @"image";

@implementation FRDRemoveImageFromGalleryRequest

#pragma mark - Lifecycle

- (instancetype)initWithGalleryPhoto:(FRDGalleryPhoto *)galleryPhoto
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"DELETE";
        
        NSMutableDictionary *parameters = [@{
                                             kImageName: galleryPhoto.photoName
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
