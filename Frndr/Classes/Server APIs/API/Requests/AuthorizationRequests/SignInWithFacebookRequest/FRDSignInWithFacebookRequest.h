//
//  FRDSignInWithFacebookRequest.h
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDSignInWithFacebookRequest : FRDNetworkRequest

@property (strong, nonatomic) NSString *userId;
@property (assign, nonatomic) BOOL avatarExists;

@end
