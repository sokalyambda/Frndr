//
//  FRDRemoveImageFromGalleryRequest.h
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@class FRDGalleryPhoto;

@interface FRDRemoveImageFromGalleryRequest : FRDNetworkRequest

- (instancetype)initWithGalleryPhoto:(FRDGalleryPhoto *)galleryPhoto;

@end
