//
//  SEProjectFacade.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDProjectFacade.h"

#import "FRDSessionManager.h"
#import "FRDChatManager.h"

#import "FRDRequests.h"

#import "FRDFacebookService.h"
#import "FRDErrorHandler.h"

#import "FRDKeychainHandler.h"
#import "FRDNearestUsersService.h"

#import "FRDSearchSettings.h"
#import "FRDAvatar.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static FRDSessionManager *sharedHTTPClient = nil;

//NSString *baseURLString = @"http://192.168.88.161:8859/"; //Misha
//NSString *baseURLString = @"http://192.168.88.47:8859/"; //Vanya
NSString *baseURLString = @"http://projects.thinkmobiles.com:8859/"; //Live

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
    //Close the channel
    [[FRDChatManager sharedChatManager] closeChannel];
    
    [self cancelAllOperations];

    if ([FRDNearestUsersService isSearchInProcess]) {
        [[FRDNearestUsersService searchTimer] invalidate];
        [FRDNearestUsersService setSearchTimer:nil];
        [FRDNearestUsersService setSearchInProcess:NO];
    }
    
    //temp
    [FRDStorageManager sharedStorage].logined = NO;
    
    [FRDStorageManager sharedStorage].currentFacebookProfile = nil;
    [FRDStorageManager sharedStorage].currentUserProfile = nil;
    
    [FRDFacebookService logoutFromFacebook];
}

#pragma mark - Requests builder

#pragma mark - User Profile Module

/**
 *  Send Current Device APNS Token
 *
 *  @param success Success Block
 *  @param failure Failure Block
 *
 *  @return Current Orepation
 */
+ (FRDNetworkOperation *)sendDeviceDataOnSuccess:(SuccessBlock)success
                                       onFailure:(FailureBlock)failure
{
    FRDSendDeviceDataRequest *request = [[FRDSendDeviceDataRequest alloc] init];
    
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
 *  Get user profile by ID
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (FRDNetworkOperation *)getUserById:(NSString *)userId onSuccess:(void(^)(FRDCurrentUserProfile *userProfile))success onFailure:(FailureBlock)failure
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

//Friends list
+ (FRDNetworkOperation *)getFriendsListWithPage:(NSInteger)page onSuccess:(void (^)(NSArray *friendsList))success
                                        onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    FRDGetFriendsListRequest *request = [[FRDGetFriendsListRequest alloc] initWithPage:page];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDGetFriendsListRequest *request = (FRDGetFriendsListRequest*)operation.networkRequest;
        
        if (success) {
            success(request.friendsList);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];;
    
    return operation;
}

+ (FRDNetworkOperation *)getFriendProfileWithFriendId:(NSString *)friendId onSuccess:(void (^)(FRDFriend *cirrentFriend))success
                                      onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    FRDGetFriendProfileRequest *request = [[FRDGetFriendProfileRequest alloc] initWithFriendId:friendId];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDGetFriendProfileRequest *request = (FRDGetFriendProfileRequest*)operation.networkRequest;
        
        if (success) {
            success(request.currentFriend);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];;
    
    return operation;
}

/******* FaceBook *******/

+ (FRDNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(NSString *userId, BOOL avatarExists, BOOL isFirstLogin))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    FRDSignInWithFacebookRequest *request = [[FRDSignInWithFacebookRequest alloc] init];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDSignInWithFacebookRequest *request = (FRDSignInWithFacebookRequest *)operation.networkRequest;
        
        if (success) {
            success(request.userId, request.avatarExists, request.isFirstLogin);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];;
    
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

/******* FaceBook *******/

#pragma mark - Search Settings Module

+ (FRDNetworkOperation *)getCurrentSearchSettingsOnSuccess:(void(^)(FRDSearchSettings *currentSearchSettings))success onFailure:(FailureBlock)failure
{
    FRDGetSearchSettingsRequest *request = [[FRDGetSearchSettingsRequest alloc] init];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDGetSearchSettingsRequest *request = (FRDGetSearchSettingsRequest *)operation.networkRequest;
        
        if (success) {
            success(request.currentSearchSettings);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

+ (FRDNetworkOperation *)updateCurrentSearchSettings:(FRDSearchSettings *)searchSettingsForUpdating onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDUpdateSearchSettingsRequest *request = [[FRDUpdateSearchSettingsRequest alloc] initWithSearchSettingsForUpdating:searchSettingsForUpdating];
    
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

#pragma mark - Likes Module

+ (FRDNetworkOperation *)dislikeUserById:(NSString *)userId onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDDislikeUserByIdRequest *request = [[FRDDislikeUserByIdRequest alloc] initWithUserId:userId];
    
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

+ (FRDNetworkOperation *)likeUserById:(NSString *)userId onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDLikeUserByIdRequest *request = [[FRDLikeUserByIdRequest alloc] initWithUserId:userId];
    
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

#pragma mark - Messages Module

+ (FRDNetworkOperation *)clearAllMessagesOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDClearAllMessagesRequest *request = [[FRDClearAllMessagesRequest alloc] init];
    
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

+ (FRDNetworkOperation *)getChatHistoryWithFriendId:(NSString *)friendId
                                            andPage:(NSInteger)page
                                          onSuccess:(void(^)(NSArray *chatHistory))success
                                          onFailure:(FailureBlock)failure
{
    FRDGetChatHistoryRequest *request = [[FRDGetChatHistoryRequest alloc] initWithFriendId:friendId andPage:page];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDGetChatHistoryRequest *request = (FRDGetChatHistoryRequest *)operation.networkRequest;
        
        if (success) {
            success(request.chatHistory);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

+ (FRDNetworkOperation *)sendMessage:(NSString *)messageBody
                      toFriendWithId:(NSString *)friendId
                           onSuccess:(SuccessBlock)success
                           onFailure:(FailureBlock)failure
{
    FRDSendMessageRequest *request = [[FRDSendMessageRequest alloc] initWithFriendId:friendId andMessageBody:messageBody];
    
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

#pragma mark - Images Module

+ (FRDNetworkOperation *)uploadUserAvatar:(UIImage *)newAvatar
                                onSuccess:(SuccessBlock)success
                                onFailure:(FailureBlock)failure
{
    FRDUploadAvatarRequest *request = [[FRDUploadAvatarRequest alloc] initWithImage:newAvatar];
    
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

//new
+ (FRDNetworkOperation *)uploadPhotoToGallery:(UIImage *)photo onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDUploadPhotoToGalleryRequest *request = [[FRDUploadPhotoToGalleryRequest alloc] initWithPhoto:photo];
    
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

+ (FRDNetworkOperation *)removeAvatarOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDRemoveAvatarRequest *request = [[FRDRemoveAvatarRequest alloc] init];
    
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

+ (FRDNetworkOperation *)removePhotoFromGallery:(FRDGalleryPhoto *)photo onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    FRDRemoveImageFromGalleryRequest *request = [[FRDRemoveImageFromGalleryRequest alloc] initWithGalleryPhoto:photo];
    
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

+ (FRDNetworkOperation *)getAvatarAndGalleryOnSuccess:(void(^)(FRDAvatar *avatar, NSArray *gallery))success onFailure:(FailureBlock)failure
{
    FRDGetAvatarAndGalleryPhotosRequest *request = [[FRDGetAvatarAndGalleryPhotosRequest alloc] init];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDGetAvatarAndGalleryPhotosRequest *request = (FRDGetAvatarAndGalleryPhotosRequest *)operation.networkRequest;
        
        if (success) {
            success(request.currentAvatar, request.galleryPhotos);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

+ (FRDNetworkOperation *)getAvatarWithSmallValue:(BOOL)small onSuccess:(void(^)(FRDAvatar *avatar))success onFailure:(FailureBlock)failure
{
    FRDGetAvatarRequest *request = [[FRDGetAvatarRequest alloc] initWithSmall:small];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDGetAvatarRequest *request = (FRDGetAvatarRequest *)operation.networkRequest;
        
        if (success) {
            success(request.currentAvatar);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

+ (FRDNetworkOperation *)getGalleryOnSuccess:(void(^)(NSArray *gallery))success onFailure:(FailureBlock)failure
{
    FRDGetGalleryPhotosRequest *request = [[FRDGetGalleryPhotosRequest alloc] init];
    
    FRDNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(FRDNetworkOperation *operation) {
        
        FRDGetGalleryPhotosRequest *request = (FRDGetGalleryPhotosRequest *)operation.networkRequest;
        
        if (success) {
            success(request.galleryPhotos);
        }
        
    } failure:^(FRDNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

#pragma mark - Reachability

+ (BOOL)isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end
