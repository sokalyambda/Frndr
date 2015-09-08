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

NSString *baseURLString = @"https://api.bizraterewards.com/v1/";

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
    [[self HTTPClient] validateSessionWithType:sessionType onSuccess:success onFailure:failure];
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

/******* FaceBook *******/
/*
+ (BZRNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(BOOL isSuccess))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled, BOOL userExists))failure
{
    __block BZRNetworkOperation* operation;
    
    [self validateSessionWithType:BZRSessionTypeApplication onSuccess:^(BOOL isSuccess) {
        BZRSignInWithFacebookRequest *request = [[BZRSignInWithFacebookRequest alloc] init];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            //track mixpanel event
            [BZRMixpanelService trackEventWithType:BZRMixpanelEventLoginSuccessful
                                     propertyValue:kAuthTypeFacebook];
            
            BZRSignInWithFacebookRequest *request = (BZRSignInWithFacebookRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].userToken = request.userToken;
            
            if (success) {
                success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
            
            BOOL isFacebookUserExists = [BZRErrorHandler isFacebookUserExistsFromError:error];
            if (isFacebookUserExists) {
                [BZRAlertFacade showFailureResponseAlertWithError:error forController:nil andCompletion:^{
                    
                }];
            }
            if (failure) {
                failure(error, isCanceled, isFacebookUserExists);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        BOOL isFacebookUserExists = [BZRErrorHandler isFacebookUserExistsFromError:error];
        if (failure) {
            failure(error, isCanceled, isFacebookUserExists);
        }
    }];
    return operation;
}

+ (BZRNetworkOperation *)signUpWithFacebookWithUserFirstName:(NSString *)firstName
                                             andUserLastName:(NSString *)lastName
                                                    andEmail:(NSString *)email
                                              andDateOfBirth:(NSString *)dateOfBirth
                                                   andGender:(NSString *)gender
                                                   onSuccess:(void (^)(BOOL isSuccess))success
                                                   onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation *operation;
    
    [self validateSessionWithType:BZRSessionTypeApplication onSuccess:^(BOOL isSuccess) {
        
        //track mixpanel event
        [BZRMixpanelService trackEventWithType:BZRMixpanelEventRegistrationSuccessful
                                 propertyValue:kAuthTypeFacebook];
        
        BZRSignUpRequest *request = [[BZRSignUpRequest alloc] initWithUserFirstName:firstName andUserLastName:lastName andEmail:email andDateOfBirth:dateOfBirth andGender:gender];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRSignUpRequest *request = (BZRSignUpRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].userToken = request.userToken;
            
            if (success) {
                success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            if (failure) {
                failure(error, isCanceled);
            }
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}
*/
/******* FaceBook *******/

+ (BOOL)isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end
