//
//  BZRKeychainHandler.h
//  BizrateRewards
//
//  Created by Eugenity on 16.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface FRDKeychainHandler : NSObject

+ (void)storeCredentialsWithUsername:(NSString*)username andPassword:(NSString*)password forService:(NSString *)serviceName;
+ (NSDictionary*)getStoredCredentialsForService:(NSString *)serviceName;

+ (void)resetKeychainForService:(NSString *)serviceName;

+ (void)resetKeychainIfFirstLaunch;

@end
