//
//  SEProjectFacade.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "FRDSessionManager.h"

extern NSString *defaultBaseURLString;

@class FRDSearchSettings;

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

#pragma mark - User Profile Module

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

#pragma mark - Search Settings Module

+ (FRDNetworkOperation *)getCurrentSearchSettingsOnSuccess:(void(^)(FRDSearchSettings *currentSearchSettings))success
                                                 onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)updateCurrentSearchSettings:(FRDSearchSettings *)searchSettingsForUpdating onSuccess:(void(^)(FRDSearchSettings *currentSearchSettings))success
                                           onFailure:(FailureBlock)failure;

#pragma mark - Likes Module

+ (FRDNetworkOperation *)dislikeUserById:(long long)userId onSuccess:(SuccessBlock)success
                               onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)likeUserById:(long long)userId onSuccess:(SuccessBlock)success
                            onFailure:(FailureBlock)failure;

#pragma mark - Messages Module

+ (FRDNetworkOperation *)clearAllMessagesOnSuccess:(SuccessBlock)success
                                         onFailure:(FailureBlock)failure;


@end