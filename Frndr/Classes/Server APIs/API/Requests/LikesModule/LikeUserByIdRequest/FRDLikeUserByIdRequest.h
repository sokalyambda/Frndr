//
//  FRDLikeUserByIdRequest.h
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDLikeUserByIdRequest : FRDNetworkRequest

- (instancetype)initWithUserId:(long long)userId;

@end
