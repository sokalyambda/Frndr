//
//  FRDUploadPhotoToGalleryRequest.m
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDUploadPhotoToGalleryRequest.h"

#import "UIImage+Base64Encoding.h"

static NSString *const requestAction = @"image/photo";

static NSString *const kImage = @"image";

static NSString *const kUploadingPatternString = @"data:image/png;base64,";

@implementation FRDUploadPhotoToGalleryRequest

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(UIImage *)photo
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        
        NSString *base64Photo = [photo encodeToBase64String];
        
        NSMutableDictionary *parameters = [@{kImage: [NSString stringWithFormat:@"%@ %@", kUploadingPatternString, base64Photo]
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
