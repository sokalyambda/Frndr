//
//  BZRFailedOperationManager.m
//  BizrateRewards
//
//  Created by Eugenity on 06.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFailedOperationManager.h"

#import "BZRProjectFacade.h"

@interface BZRFailedOperationManager ()

@property (strong, nonatomic) BZRSessionManager *sessionManager;
@property (strong, nonatomic) BZRNetworkRequest *currentFailedRequest;

@property (copy, nonatomic) SuccessOperationBlock successBlock;
@property (copy, nonatomic) FailureOperationBlock failureBlock;

@end

@implementation BZRFailedOperationManager

#pragma mark - Accessors

- (BZRSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [BZRProjectFacade HTTPClient];
    }
    return _sessionManager;
}

#pragma mark - Lifecycle

+ (BZRFailedOperationManager *)sharedManager
{
    static BZRFailedOperationManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BZRFailedOperationManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Actions

/**
 *  Restart failed operation
 */
- (void)restartFailedOperation
{
    [self.sessionManager enqueueOperationWithNetworkRequest:self.currentFailedRequest success:self.successBlock failure:self.failureBlock];
}

/**
 *  Add failed operation and restart it
 *
 *  @param operation Failed Operation
 */
- (void)addAndRestartFailedOperation:(BZRNetworkOperation *)operation
{
    if (![self.currentFailedRequest isEqual:operation.networkRequest]) {
        self.currentFailedRequest = operation.networkRequest;
        [self restartFailedOperation];
    } else {
        [self restartFailedOperation];
    }
}

/**
 *  Set completion blocks to failed operation manager
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
- (void)setFailedOperationSuccessBlock:(SuccessOperationBlock)success andFailureBlock:(FailureOperationBlock)failure
{
    if (success) {
        self.successBlock = success;
    }
    if (failure) {
        self.failureBlock = failure;
    }
}

@end
