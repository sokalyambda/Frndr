//
//  SESessionManager.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSessionManager.h"
#import "BZRFailedOperationManager.h"

#import "BZRNetworkOperation.h"

#import "BZRReachabilityHelper.h"

#import "BZRErrorHandler.h"

#import "BZRAlertFacade.h"

#import "BZRRenewSessionTokenRequest.h"
#import "BZRGetClientCredentialsRequest.h"

static CGFloat const kRequestTimeInterval = 60.f;
static NSInteger const kMaxConcurentRequests = 100.f;
static NSInteger const kAllCleansCount = 1.f;

static NSString *const kCleanSessionLock = @"CleanSessionLock";

@interface BZRSessionManager ()

@property (copy, nonatomic) CleanBlock cleanBlock;

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) BZRFailedOperationManager *failedOperationManager;

@property (assign, nonatomic) AFNetworkReachabilityStatus reachabilityStatus;

@property (strong, readwrite, nonatomic) NSURL *baseURL;

@property (strong, nonatomic) NSMutableArray *operationsQueue;
@property (strong, nonatomic) NSLock *lock;

@property (assign, nonatomic) NSUInteger cleanCount;

@property (strong, nonatomic) AFHTTPRequestSerializer *HTTPRequestSerializer;
@property (strong, nonatomic) AFJSONRequestSerializer *JSONRequestSerializer;

@end

@implementation BZRSessionManager

#pragma mark - Accessors

- (BZRFailedOperationManager *)failedOperationManager
{
    if (!_failedOperationManager) {
        _failedOperationManager = [BZRFailedOperationManager sharedManager];
    }
    return _failedOperationManager;
}

- (AFJSONRequestSerializer *)JSONRequestSerializer
{
    if (!_JSONRequestSerializer) {
        _JSONRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _JSONRequestSerializer;
}

- (AFHTTPRequestSerializer *)HTTPRequestSerializer
{
    if (!_HTTPRequestSerializer) {
        _HTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _HTTPRequestSerializer;
}

#pragma mark - Lifecycle

- (id)initWithBaseURL:(NSURL*)url
{
    if (self = [super init]) {
        
        self.baseURL = url;
        
        if ([NSURLSession class]) {
            NSURLSessionConfiguration* taskConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            taskConfig.HTTPMaximumConnectionsPerHost = kMaxConcurentRequests;
            taskConfig.timeoutIntervalForRequest = kRequestTimeInterval;
            taskConfig.timeoutIntervalForResource = kRequestTimeInterval;
            taskConfig.allowsCellularAccess = YES;
            
            _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:taskConfig];
            
            [_sessionManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
            [_sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/schema+json", @"application/json", @"application/x-www-form-urlencoded", @"application/hal+json", nil]];
        }
        
        self.lock = [[NSLock alloc] init];
        self.lock.name = kCleanSessionLock;
        
        self.operationsQueue = [NSMutableArray array];
        
        WEAK_SELF;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        weakSelf.reachabilityStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            weakSelf.reachabilityStatus = status;
            
#ifdef DEBUG
            NSString* stateText = nil;
            switch (weakSelf.reachabilityStatus) {
                case AFNetworkReachabilityStatusUnknown: {
                    stateText = @"Network reachability is unknown";
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable: {
                    stateText = @"Network is not reachable";
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    stateText = @"Network is reachable via WWAN";
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    stateText = @"Network is reachable via WiFi";
                    break;
                }
            }
            NSLog(@"%@", stateText);
#endif
        }];

        self.requestNumber = 0;
        
    }
    return self;
}

#pragma mark - Actions

- (void)cleanManagersWithCompletionBlock:(CleanBlock)block
{
    if ([NSURLSession class]) {
        self.cleanCount = 0;
        self.cleanBlock = block;
        WEAK_SELF;
        [_sessionManager setSessionDidBecomeInvalidBlock:^(NSURLSession *session, NSError *error) {
            [weakSelf syncCleans];
            weakSelf.sessionManager = nil;
        }];
        [_sessionManager invalidateSessionCancelingTasks:YES];
    }
}

- (void)syncCleans
{
    [self.lock lock];
    self.cleanCount++;
    [self.lock unlock];
    
    if (self.cleanCount == kAllCleansCount) {
        if (self.cleanBlock) {
            self.cleanBlock();
        }
    }
}

- (id)manager
{
    if (_sessionManager) {
        return _sessionManager;
    }
    return nil;
}

-(void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - Operation cycle

- (BZRNetworkOperation*)enqueueOperationWithNetworkRequest:(BZRNetworkRequest*)networkRequest success:(SuccessOperationBlock)success
                                                  failure:(FailureOperationBlock)failure
{
    //set success&failure blocks to failed operation manager. This step adds a possibility to restart operation if connection failed
    [self.failedOperationManager setFailedOperationSuccessBlock:success andFailureBlock:failure];
    
    NSError *error = nil;
    id manager = nil;
    
    if ([NSURLSession class]) {
        manager = _sessionManager;
    }
    
    switch (networkRequest.serializationType) {
        case BZRRequestSerializationTypeHTTP:
            [(AFHTTPSessionManager *)manager setRequestSerializer:self.HTTPRequestSerializer];
            break;
            
        case BZRRequestSerializationTypeJSON:
            [(AFHTTPSessionManager *)manager setRequestSerializer:self.JSONRequestSerializer];
            break;
            
        default:
            break;
    }
    
    BZRNetworkOperation *operation = [[BZRNetworkOperation alloc] initWithNetworkRequest:networkRequest networkManager:manager error:&error];
    
    WEAK_SELF;
    if (error && failure) {
        failure(operation ,error, NO);
    } else {
        [self enqueueOperation:operation success:^(BZRNetworkOperation *operation) {
            
            [weakSelf finishOperationInQueue:operation];
            if (success) {
                success(operation);
            }
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
            
            [weakSelf finishOperationInQueue:operation];
            
            if ([BZRErrorHandler errorIsNetworkError:error] && operation.networkRequest.retryIfConnectionFailed) {
                
                [BZRAlertFacade showRetryInternetConnectionAlertForController:nil withCompletion:^(BOOL retry) {
                    if (!retry && failure) {
                        failure(operation, error, isCanceled);
                    } else {
                        [weakSelf.failedOperationManager addAndRestartFailedOperation:operation];
                    }
                }];
            } else if (failure) {
                failure(operation, error, isCanceled);
            }
        }];
    }
    return operation;
}

- (void)enqueueOperation:(BZRNetworkOperation*)operation success:(SuccessOperationBlock)success failure:(FailureOperationBlock)failure
{
    WEAK_SELF;
    //check reachability
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        
        [operation setCompletionBlockAfterProcessingWithSuccess:success failure:failure];
        [weakSelf addOperationToQueue:operation];
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(operation, error, NO);
        }
    }];
}

/**
 *  Cancel all operations
 */
- (void)cancelAllOperations
{
    if ([NSURLSession class]) {
        for (BZRNetworkOperation *operation in self.operationsQueue) {
            [operation cancel];
        }
        [self.sessionManager.operationQueue cancelAllOperations];
    }
}

/**
 *  Check whether operation is in process
 *
 *  @return Returns 'YES' in any operation is in process
 */
- (BOOL)isOperationInProcess
{
    for (BZRNetworkOperation *operation in self.operationsQueue) {
        if ([operation isInProcess]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  Remove operation from normal queue
 *
 *  @param operation Operation that has to be removed
 */
- (void)finishOperationInQueue:(BZRNetworkOperation*)operation
{
    [self.operationsQueue removeObject:operation];
}

/**
 *  Add new operation to normal queue
 *
 *  @param operation Operation that has to be added to queue
 */
- (void)addOperationToQueue:(BZRNetworkOperation*)operation
{
    [self.operationsQueue addObject:operation];
    
    [operation start];
}

/**
 *  Validate session and renew token if needed
 *
 *  @param sessionType Type of session for validation
 *  @param success     Success Block
 *  @param failure     Failure Block
 */
- (void)validateSessionWithType:(BZRSessionType)sessionType onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    BOOL isValid = [self isSessionValidWithType:sessionType];
    
    if (!isValid && sessionType == BZRSessionTypeUser) {
        [self renewSessionTokenOnSuccess:^(BOOL isSuccess) {
            if (success) {
                success(isSuccess);
            }
        } onFailure:^(NSError *error, BOOL isCanceled) {
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } else if (!isValid && sessionType == BZRSessionTypeApplication) {
        [self getClientCredentialsOnSuccess:^(BOOL isSuccess) {
            if (success) {
                success(isSuccess);
            }
        } onFailure:^(NSError *error, BOOL isCanceled) {
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } else {
        if (success) {
            success(YES);
        }
    }
}

/**
 *  Validate current session with specific type
 *
 *  @param sessionType Type of session for validation
 *
 *  @return Returns 'YES' if session is valid
 */
- (BOOL)isSessionValidWithType:(BZRSessionType)sessionType
{
    NSString *accessToken;
    NSDate *tokenExpirationDate;
    
    switch (sessionType) {
        case BZRSessionTypeApplication: {
            accessToken = [BZRStorageManager sharedStorage].applicationToken.accessToken;
            tokenExpirationDate = [BZRStorageManager sharedStorage].applicationToken.expirationDate;
            break;
        }
        case BZRSessionTypeUser: {
            accessToken = [BZRStorageManager sharedStorage].userToken.accessToken;
            tokenExpirationDate = [BZRStorageManager sharedStorage].userToken.expirationDate;
            break;
        }
        default:
            break;
    }
    
    return (accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending));
}

#pragma mark - Renew Session Token

/**
 *  Reauthorize user session
 *
 *  @param success Success Block
 *  @param failure Failure Block
 *
 *  @return BZRNetworkOperation
 */
- (BZRNetworkOperation *)renewSessionTokenOnSuccess:(void (^)(BOOL isSuccess))success
                                              onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRRenewSessionTokenRequest *request = [[BZRRenewSessionTokenRequest alloc] init];
    BZRNetworkOperation *operation = [self enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRRenewSessionTokenRequest *request = (BZRRenewSessionTokenRequest *)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.token;
        
        if (success) {
            success(YES);
        }
        
    } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error, isCanceled);
        }
        
    }];
    return operation;
}

#pragma mark - Get Application Token

/**
 *  Authorize application session
 *
 *  @param success Success Block
 *  @param failure Failure Block
 *
 *  @return BZRNetworkOperation
 */
- (BZRNetworkOperation *)getClientCredentialsOnSuccess:(void (^)(BOOL success))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRGetClientCredentialsRequest *request = [[BZRGetClientCredentialsRequest alloc] init];
    
    BZRNetworkOperation *operation = [self enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRGetClientCredentialsRequest *request = (BZRGetClientCredentialsRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].applicationToken = request.token;
        
        if (success) {
            success(YES);
        }
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        [BZRAlertFacade showFailureResponseAlertWithError:error forController:nil andCompletion:^{
            
        }];
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return operation;
}

@end
