//
//  SESessionManager.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    FRDSessionTypeApplication,
    FRDSessionTypeUser
} FRDSessionType;

#import "FRDNetworkOperation.h"

typedef void (^CleanBlock)();

@interface FRDSessionManager : NSObject

@property (assign, atomic) NSInteger requestNumber;

@property (strong, nonatomic, readonly) NSURL *baseURL;

- (id)initWithBaseURL:(NSURL*)url;
- (void)cancelAllOperations;
- (void)cleanManagersWithCompletionBlock:(CleanBlock)block;

- (void)enqueueOperation:(FRDNetworkOperation*)operation success:(SuccessOperationBlock)success failure:(FailureOperationBlock)failure;
- (FRDNetworkOperation*)enqueueOperationWithNetworkRequest:(FRDNetworkRequest*)networkRequest success:(SuccessOperationBlock)success failure:(FailureOperationBlock)failure;

//session validation
- (void)validateSessionWithType:(FRDSessionType)sessionType onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;
- (BOOL)isSessionValidWithType:(FRDSessionType)sessionType;

//check whether operation is in process
- (BOOL)isOperationInProcess;

@end
