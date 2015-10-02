//
//  FRDNearestUsersService.h
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef void(^SuccessNearestUsersBlock)(NSArray *nearestUsers);
typedef void(^FailureNearestUsersBlock)(NSError *error);

@interface FRDNearestUsersService : NSObject

+ (BOOL)isSearchInProcess;

+ (void)getNearestUsersWithPage:(NSInteger)page
                      onSuccess:(SuccessNearestUsersBlock)success
                      onFailure:(FailureNearestUsersBlock)failure;

@end
