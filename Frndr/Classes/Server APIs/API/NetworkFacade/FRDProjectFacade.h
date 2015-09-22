//
//  SEProjectFacade.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "FRDSessionManager.h"

extern NSString *defaultBaseURLString;

@class BZRUserProfile, BZRLocationEvent;

@interface FRDProjectFacade : NSObject

+ (FRDSessionManager *)HTTPClient;

+ (void)initHTTPClientWithRootPath:(NSString*)baseURL withCompletion:(void(^)(void))completion;

//internet checking
+ (BOOL)isInternetReachable;

//session validation
+ (BOOL)isUserSessionValid;
+ (BOOL)isFacebookSessionValid;

//cancel operations
+ (void)cancelAllOperations;

//check whether any operation is in process
+ (BOOL)isOperationInProcess;

//Authorization Requests

//Sign Out
+ (void)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//Facebook
+ (FRDNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(BOOL isSuccess))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;


@end