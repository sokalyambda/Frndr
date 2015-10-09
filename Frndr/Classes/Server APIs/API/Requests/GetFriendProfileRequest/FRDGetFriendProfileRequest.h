//
//  FRDGetFriendProfileRequest.h
//  Frndr
//
//  Created by Eugenity on 09.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@class FRDFriend;

@interface FRDGetFriendProfileRequest : FRDNetworkRequest

@property (strong, nonatomic) FRDFriend *currentFriend;

@end
