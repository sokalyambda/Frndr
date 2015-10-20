//
//  FRDChangeAvatarFromGalleryRequest.h
//  Frndr
//
//  Created by Eugenity on 20.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@class FRDGalleryPhoto;

@interface FRDChangeAvatarFromGalleryRequest : FRDNetworkRequest

@property (strong, nonatomic) FRDAvatar *updatedAvatar;

- (instancetype)initWithGalleryPhoto:(FRDGalleryPhoto *)galleryPhoto;

@end
