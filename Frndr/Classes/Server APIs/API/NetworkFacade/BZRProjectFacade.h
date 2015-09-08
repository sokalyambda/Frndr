//
//  SEProjectFacade.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "BZRSessionManager.h"

extern NSString *defaultBaseURLString;

@class BZRUserProfile, BZRLocationEvent;

@interface BZRProjectFacade : NSObject

+ (BZRSessionManager *)HTTPClient;

+ (NSString *)baseURLString;
+ (void)setBaseURLString:(NSString *)baseURLString;
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

//GET API Info Request
+ (BZRNetworkOperation *)getAPIInfoOnSuccess:(void (^)(BOOL success))success
                                   onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Authorization Requests
+ (BZRNetworkOperation*)signInWithEmail:(NSString*)email
                              password:(NSString*)password
                               success:(void (^)(BOOL success))success
                               failure:(void (^)(NSError *error, BOOL isCanceled, BOOL emailRegistered))failure;

+ (BZRNetworkOperation*)signUpWithUserFirstName:(NSString *)firstName
                                andUserLastName:(NSString *)lastName
                                       andEmail:(NSString *)email
                                    andPassword:(NSString *)password
                                 andDateOfBirth:(NSString *)birthDate
                                      andGender:(NSString *)gender
                                        success:(void (^)(BOOL success))success
                                        failure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (BZRNetworkOperation *)resetPasswordWithUserName:(NSString *)userName
                                    andNewPassword:(NSString *)newPassword
                                         onSuccess:(void (^)(BOOL isSuccess))success
                                         onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//User Profile Requests
+ (BZRNetworkOperation*)getCurrentUserOnSuccess:(void (^)(BOOL isSuccess))success
                                      onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (BZRNetworkOperation*)updateUserWithFirstName:(NSString *)firstName
                                    andLastName:(NSString *)lastName
                                 andDateOfBirth:(NSString *)dateOfBirth
                                      andGender:(NSString *)gender
                                      onSuccess:(void (^)(BOOL success))success
                                      onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Surveys Requests
+ (BZRNetworkOperation*)getEligibleSurveysOnSuccess:(void (^)(NSArray *surveys))success
                                          onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (BZRNetworkOperation *)getPointsForNextSurveyOnSuccess:(void(^)(NSInteger pointsForNextSurvey))success onFailure:(void(^)(NSError *error, BOOL isCanceled))failure;

//Location Events
+ (BZRNetworkOperation *)sendGeolocationEvent:(BZRLocationEvent *)locationEvent onSuccess:(void (^)(BZRLocationEvent *locationEvent))success
                                    onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;
+ (BZRNetworkOperation *)getGeolocationEventsListOnSuccess:(void (^)(NSArray *locationEvents))success
                                    onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Device Requests
+ (BZRNetworkOperation *)sendDeviceDataOnSuccess:(void (^)(BOOL isSuccess))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Gift Cards Requests
+ (BZRNetworkOperation *)getFeaturedGiftCardsOnSuccess:(void (^)(NSArray *giftCards))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Sign Out
+ (void)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//Facebook
+ (BZRNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(BOOL isSuccess))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled, BOOL userExists))failure;

+ (BZRNetworkOperation *)signUpWithFacebookWithUserFirstName:(NSString *)firstName
                                             andUserLastName:(NSString *)lastName
                                                    andEmail:(NSString *)email
                                              andDateOfBirth:(NSString *)dateOfBirth
                                                   andGender:(NSString *)gender
                                                   onSuccess:(void (^)(BOOL isSuccess))success
                                                   onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

@end