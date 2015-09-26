//
//  SEProjectFacade.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDProjectFacade.h"

#import "FRDSessionManager.h"

#import "FRDRequests.h"

#import "FRDFacebookService.h"
#import "FRDErrorHandler.h"

#import "FRDKeychainHandler.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static FRDSessionManager *sharedHTTPClient = nil;

//NSString *baseURLString = @"http://192.168.88.55:8859/";
NSString *baseURLString = @"http://134.249.164.53:8859/";

@implementation FRDProjectFacade

#pragma mark - Lifecycle

+ (FRDSessionManager *)HTTPClient
{
    if (!sharedHTTPClient) {
        [self initHTTPClientWithRootPath:baseURLString withCompletion:nil];
    }
    return sharedHTTPClient;
}

+ (void)initHTTPClientWithRootPath:(NSString*)baseURL withCompletion:(void(^)(void))completion
{
    if (sharedHTTPClient) {
        
        [sharedHTTPClient cleanManagersWithCompletionBlock:^{
            
            sharedHTTPClient = nil;
            AFNetworkActivityIndicatorManager.sharedManager.enabled = NO;
            
            sharedHTTPClient = [[FRDSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];

            AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
            
            if (completion) {
                completion();
            }
        }];
    } else {
        sharedHTTPClient = [[FRDSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Actions

/**
 *  Cancel all operations
 */
+ (void)cancelAllOperations
{
    return [sharedHTTPClient cancelAllOperations];
}

/**
 *  Check whether the operation is in process
 *
 *  @return Returns 'YES' if any opretaion is in process
 */
+ (BOOL)isOperationInProcess
{
    return [[self HTTPClient] isOperationInProcess];
}

/**
 *  Clear current user data
 */
+ (void)clearUserData
{
    [self cancelAllOperations];
    
    [FRDStorageManager sharedStorage].currentFacebookProfile = nil;
    
    [FRDFacebookService logoutFromFacebook];
}

#pragma mark - Requests builder

/**
 *  Get user profile by ID
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (FRDNetworkOperation *)getUserById:(NSInteger)userId onSuccess:(void(^)(FRDCurrentUserProfile *userProfile))success onFailure:(FailureBlock)failure
{
    FRDGetUserByIdRequest *request = [[FRDGetUserByIdRequest alloc] initWithUserId:userId];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDGetUserByIdRequest *request = (FRDGetUserByIdRequest *)operation.networkRequest;
        
        if (success) {
            success(request.userProfile);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

/**
 *  Get current user profile
 *
 *  @param success Success Block
 *  @param failure Failure Block
 *
 */
+ (FRDNetworkOperation *)getCurrentUserProfileOnSuccess:(SuccessBlock)success
                                              onFailure:(FailureBlock)failure
{
    FRDGetCurrentUserProfileRequest *request = [[FRDGetCurrentUserProfileRequest alloc] init];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        if (success) {
            success(YES);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

/**
 *  Update notifications settings
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (FRDNetworkOperation *)updateNotificationsSettingsOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDUpdateNotificationsSettingsRequest *request = [[FRDUpdateNotificationsSettingsRequest alloc] init];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        if (success) {
            success(YES);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

/**
 *  Sign out from current account
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (FRDNetworkOperation *)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDSignOutRequest *request = [[FRDSignOutRequest alloc] init];
    
    WEAK_SELF;
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        [weakSelf clearUserData];
        
        if (success) {
            success(YES);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

/**
 *  Delete current account
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (FRDNetworkOperation *)deleteAccountOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDDeleteCurrentUserRequest *request = [[FRDDeleteCurrentUserRequest alloc] init];
    
    WEAK_SELF;
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        [weakSelf clearUserData];
        
        if (success) {
            success(YES);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

/**
 *  Check whether facebook session is valid
 *
 *  @return Returns 'YES' if facebook session is valid
 */
+ (BOOL)isFacebookSessionValid
{
    return [FRDFacebookService isFacebookSessionValid];
}

#pragma mark - Requests Builder

+ (FRDNetworkOperation *)updatedProfile:(FRDCurrentUserProfile *)updatedProfile
                                        onSuccess:(void (^)(FRDCurrentUserProfile *confirmedProfile))success

                                        onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    FRDUpdateProfileRequest *request = [[FRDUpdateProfileRequest alloc] initWithUpdatedProfile:updatedProfile];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDUpdateProfileRequest *request = (FRDUpdateProfileRequest*)operation.networkRequest;
        
        if (success) {
            success(request.confirmedProfile);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

+ (FRDNetworkOperation *)findNearestUsersWithPage:(NSInteger)page onSuccess:(void (^)(NSArray *nearestUsers))success
                                         onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    FRDFindNearestUsersRequest *request = [[FRDFindNearestUsersRequest alloc] initWithPage:page];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDFindNearestUsersRequest *request = (FRDFindNearestUsersRequest*)operation.networkRequest;
        
        if (success) {
            success(request.nearestUsers);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];;
    
    return operation;
}

/******* FaceBook *******/

+ (FRDNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(BOOL isSuccess))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    FRDSignInWithFacebookRequest *request = [[FRDSignInWithFacebookRequest alloc] init];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        if (success) {
            success(YES);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];;

    return operation;
}

/******* FaceBook *******/

+ (BOOL)isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end
