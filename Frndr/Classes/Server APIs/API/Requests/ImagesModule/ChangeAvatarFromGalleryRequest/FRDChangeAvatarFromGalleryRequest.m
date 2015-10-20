//
//  FRDChangeAvatarFromGalleryRequest.m
//  Frndr
//
//  Created by Eugenity on 20.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChangeAvatarFromGalleryRequest.h"

#import "FRDGalleryPhoto.h"

static NSString *const kRequestAction = @"image/avatar";

static NSString *const kNewAvatar = @"newAvatar";

@interface FRDChangeAvatarFromGalleryRequest ()

@property (strong, nonatomic) FRDGalleryPhoto *photoForUpdating;

@end

@implementation FRDChangeAvatarFromGalleryRequest

#pragma mark - Lifecycle

- (instancetype)initWithGalleryPhoto:(FRDGalleryPhoto *)galleryPhoto
{
    self = [super init];
    if (self) {

        _photoForUpdating = galleryPhoto;
        
        self.action = kRequestAction;
        _method = @"PUT";
        
        NSMutableDictionary *parameters = [@{kNewAvatar: galleryPhoto.photoName
                                             } mutableCopy];
        
        self.serializationType = FRDRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    self.updatedAvatar = (FRDAvatar *)self.photoForUpdating;
    return !!self.updatedAvatar;
}

@end
