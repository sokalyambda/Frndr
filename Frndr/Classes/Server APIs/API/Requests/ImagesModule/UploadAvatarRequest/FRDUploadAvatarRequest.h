//
//  FRDUploadAvatarRequest.h
//  Frndr
//
//  Created by Eugenity on 04.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDUploadAvatarRequest : FRDNetworkRequest

- (instancetype)initWithImage:(UIImage *)newAvatar;

@end
