//
//  BZRFailedOperationManager.h
//  BizrateRewards
//
//  Created by Eugenity on 06.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDNetworkOperation.h"

@interface FRDFailedOperationManager : NSObject

+ (FRDFailedOperationManager *)sharedManager;

- (void)addAndRestartFailedOperation:(FRDNetworkOperation *)operation;
- (void)setFailedOperationSuccessBlock:(SuccessOperationBlock)success andFailureBlock:(FailureOperationBlock)failure;

@end
