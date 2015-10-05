//
//  FRDGetAvatarAndGalleryPhotosRequest.h
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@class FRDAvatar;

@interface FRDGetAvatarAndGalleryPhotosRequest : FRDNetworkRequest

@property (strong, nonatomic) NSArray *galleryPhotos;
@property (strong, nonatomic) FRDAvatar *currentAvatar;

@end
