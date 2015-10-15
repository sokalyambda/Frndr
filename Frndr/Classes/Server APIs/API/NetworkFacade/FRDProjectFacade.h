//
//  SEProjectFacade.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "FRDSessionManager.h"

extern NSString *defaultBaseURLString;

@class FRDSearchSettings, FRDAvatar, FRDGalleryPhoto, FRDFriend;

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

//Send Device Data
+ (FRDNetworkOperation *)sendDeviceDataOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

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

+ (FRDNetworkOperation *)getUserById:(NSString *)userId
                           onSuccess:(void(^)(FRDCurrentUserProfile *userProfile))success
                           onFailure:(FailureBlock)failure;

+ (FRDNetworkOperation *)getCurrentUserProfileOnSuccess:(SuccessBlock)success
                           onFailure:(FailureBlock)failure;


//Nearest Users
+ (FRDNetworkOperation *)findNearestUsersWithPage:(NSInteger)page onSuccess:(void (^)(NSArray *nearestUsers))success
                                        onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Friends List
+ (FRDNetworkOperation *)getFriendsListWithPage:(NSInteger)page onSuccess:(void (^)(NSArray *friendsList))success
                                      onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;
+ (FRDNetworkOperation *)blockFriendWithId:(NSString *)friendId
                                 onSuccess:(SuccessBlock)success
                                 onFailure:(FailureBlock)failure;

//Friend Profile
+ (FRDNetworkOperation *)getFriendProfileWithFriendId:(NSString *)friendId onSuccess:(void (^)(FRDFriend *currentFriend))success
                                            onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Facebook
+ (FRDNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(NSString *userId, BOOL avatarExists, BOOL isFirstLogin))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

#pragma mark - Search Settings Module

+ (FRDNetworkOperation *)getCurrentSearchSettingsOnSuccess:(void(^)(FRDSearchSettings *currentSearchSettings))success
                                                 onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)updateCurrentSearchSettings:(FRDSearchSettings *)searchSettingsForUpdating onSuccess:(SuccessBlock)success
                                           onFailure:(FailureBlock)failure;

#pragma mark - Likes Module

+ (FRDNetworkOperation *)dislikeUserById:(NSString *)userId onSuccess:(SuccessBlock)success
                               onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)likeUserById:(NSString *)userId onSuccess:(SuccessBlock)success
                            onFailure:(FailureBlock)failure;

#pragma mark - Messages Module
+ (FRDNetworkOperation *)clearMessageWithId:(NSString *)messageId
                                  onSuccess:(SuccessBlock)success
                                  onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)clearAllMessagesOnSuccess:(SuccessBlock)success
                                         onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)getChatHistoryWithFriendId:(NSString *)friendId
                                            andPage:(NSInteger)page
                                          onSuccess:(void(^)(NSArray *chatHistory))success
                                          onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)sendMessage:(NSString *)messageBody
                      toFriendWithId:(NSString *)friendId
                           onSuccess:(SuccessBlock)success
                           onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)clearMessagesWithFriendWithId:(NSString *)friendId
                                             onSuccess:(SuccessBlock)success
                                             onFailure:(FailureBlock)failure;

#pragma mark - Images Module

+ (FRDNetworkOperation *)uploadUserAvatar:(UIImage *)newAvatar
                                onSuccess:(SuccessBlock)success
                                onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)uploadPhotoToGallery:(UIImage *)photo onSuccess:(SuccessBlock)success
                                    onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)removeAvatarOnSuccess:(SuccessBlock)success
                                     onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)removePhotoFromGallery:(FRDGalleryPhoto *)photo
                                      onSuccess:(SuccessBlock)success
                                      onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)getAvatarAndGalleryOnSuccess:(void(^)(FRDAvatar *avatar, NSArray *gallery))success
                                            onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)getAvatarWithSmallValue:(BOOL)small onSuccess:(void(^)(FRDAvatar *avatar))success
                                       onFailure:(FailureBlock)failure;
+ (FRDNetworkOperation *)getGalleryOnSuccess:(void(^)(NSArray *gallery))success
                                   onFailure:(FailureBlock)failure;

@end