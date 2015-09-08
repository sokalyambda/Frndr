//
//  BZRReachabilityHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface FRDReachabilityHelper : NSObject

+ (void)checkConnectionOnSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

+ (BOOL)isInternetAvaliable;

@end
