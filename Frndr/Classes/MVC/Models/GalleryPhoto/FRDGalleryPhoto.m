//
//  FRDGalleryPhoto.m
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGalleryPhoto.h"

static NSString *const kPhotoName = @"fileName";
static NSString *const kPhotoURL = @"url";

@implementation FRDGalleryPhoto

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _photoName = response[kPhotoName];
        _photoURL = [NSURL URLWithString:response[kPhotoURL]];
    }
    return self;
}

@end
