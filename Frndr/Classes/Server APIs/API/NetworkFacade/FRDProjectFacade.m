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

NSString *baseURLString = @"http://192.168.88.99:8859/";

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

#pragma mark - Requests builder

/**
 *  Sign out from current account
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (void)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self cancelAllOperations];
    
    /*
    [BZRStorageManager sharedStorage].currentProfile = nil;
    [BZRStorageManager sharedStorage].applicationToken = nil;
    [BZRStorageManager sharedStorage].userToken = nil;
    [BZRStorageManager sharedStorage].facebookProfile = nil;
    
    [BZRKeychainHandler resetKeychainForService:UserCredentialsKey];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RememberMeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [BZRFacebookService logoutFromFacebook];
    */
    
    if (success) {
        success(YES);
    }
}

/**
 *  Session validation, if not valid - renew session token
 *
 *  @param sessionType Type of session (application or user)
 *  @param success     Success Block
 *  @param failure     Failure Block
 */
+ (void)validateSessionWithType:(FRDSessionType)sessionType onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{

}

/**
 *  Check whether user session is valid
 *
 *  @return Returns 'YES' if user session is valid
 */
+ (BOOL)isUserSessionValid
{
    return [[self HTTPClient] isSessionValidWithType:FRDSessionTypeUser];
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

+ (FRDNetworkOperation *)updatedProfile:(FRDFacebookProfile *)updatedProfile
                                        onSuccess:(void (^)(FRDFacebookProfile *confirmedProfile))success

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
    }];;
    
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
