//
//  FRDBlockFriendRequest.h
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@class FRDFriend;

@interface FRDBlockFriendRequest : FRDNetworkRequest

- (instancetype)initWithFriend:(FRDFriend *)currentFriend;

@end
