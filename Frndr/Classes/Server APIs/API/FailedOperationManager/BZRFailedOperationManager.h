//
//  BZRFailedOperationManager.h
//  BizrateRewards
//
//  Created by Eugenity on 06.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkOperation.h"

@interface BZRFailedOperationManager : NSObject

+ (BZRFailedOperationManager *)sharedManager;

- (void)addAndRestartFailedOperation:(BZRNetworkOperation *)operation;
- (void)setFailedOperationSuccessBlock:(SuccessOperationBlock)success andFailureBlock:(FailureOperationBlock)failure;

@end
