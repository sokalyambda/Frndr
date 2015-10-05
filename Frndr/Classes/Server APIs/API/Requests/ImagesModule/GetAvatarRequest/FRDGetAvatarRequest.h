//
//  FRDGetAvatarRequest.h
//  Frndr
//
//  Created by Eugenity on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@class FRDAvatar;

@interface FRDGetAvatarRequest : FRDNetworkRequest

@property (strong, nonatomic) FRDAvatar *currentAvatar;

- (instancetype)initWithSmall:(BOOL)small;

@end
