//
//  BZRReachabilityHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDReachabilityHelper.h"

#import "FRDProjectFacade.h"

static NSString *const kInternetIsNotReachableString = @"Internet Is Not Reachable";

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
        NSError *internetError = [NSError errorWithDomain:@"" code:NSURLErrorNotConnectedToInternet userInfo:@{NSLocalizedDescriptionKey: kInternetIsNotReachableString}];
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
    return [FRDProjectFacade isInternetReachable];
}

@end
