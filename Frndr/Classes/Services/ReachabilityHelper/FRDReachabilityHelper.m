//
//  BZRReachabilityHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDReachabilityHelper.h"

@implementation FRDReachabilityHelper

/**
 *  Check internet reachability
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (void)checkConnectionOnSuccess:(void (^)())success failure:(void (^)(NSError *error))failure
{
    BOOL isInternetAvaliable = [self isInternetAvaliable];
    if (isInternetAvaliable) {
        if (success) {
            success();
        }
    } else {
        NSError *internetError = [NSError errorWithDomain:@"" code:NSURLErrorNotConnectedToInternet userInfo:@{NSLocalizedDescriptionKey: InternetIsNotReachableString}];
        if (failure) {
            failure(internetError);
        }
    }
}

/**
 *  Checking for reachability
 *
 *  @return If internet is reachable - returns 'YES'
 */
+ (BOOL)isInternetAvaliable
{
    return YES;
//    return [BZRProjectFacade isInternetReachable];
}

@end
