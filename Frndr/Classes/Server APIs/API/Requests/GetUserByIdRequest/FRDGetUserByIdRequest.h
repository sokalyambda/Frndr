//
//  FRDGetUserByIdRequest.h
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@class FRDCurrentUserProfile;

@interface FRDGetUserByIdRequest : FRDNetworkRequest

@property (strong, nonatomic) FRDCurrentUserProfile *userProfile;

- (instancetype)initWithUserId:(NSString *)userId;

@end
