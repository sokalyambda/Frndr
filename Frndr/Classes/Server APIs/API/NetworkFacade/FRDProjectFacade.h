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
+ (BOOL)isFacebookSessionValid;

//cancel operations
+ (void)cancelAllOperations;

//check whether any operation is in process
+ (BOOL)isOperationInProcess;

//Authorization Requests

//Sign Out
+ (FRDNetworkOperation *)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//Delete account
+ (FRDNetworkOperation *)deleteAccountOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//Update notifications settings
+ (FRDNetworkOperation *)updateNotificationsSettingsOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//User Profile
+ (FRDNetworkOperation *)updatedProfile:(FRDCurrentUserProfile *)updatedProfile
                              onSuccess:(void (^)(FRDCurrentUserProfile *confirmedProfile))success

                              onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (FRDNetworkOperation *)getUserById:(NSInteger)userId
                           onSuccess:(void(^)(FRDCurrentUserProfile *userProfile))success
                           onFailure:(FailureBlock)failure;

+ (FRDNetworkOperation *)getCurrentUserProfileOnSuccess:(SuccessBlock)success
                           onFailure:(FailureBlock)failure;


//Nearest Users
+ (FRDNetworkOperation *)findNearestUsersWithPage:(NSInteger)page onSuccess:(void (^)(NSArray *nearestUsers))success
                                        onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Facebook
+ (FRDNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(BOOL isSuccess))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;


@end