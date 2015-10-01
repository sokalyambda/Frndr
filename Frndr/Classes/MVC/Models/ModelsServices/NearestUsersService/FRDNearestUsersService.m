//
//  FRDNearestUsersService.m
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNearestUsersService.h"

#import "FRDProjectFacade.h"



@implementation FRDNearestUsersService

#pragma mark - Actions

+ (void)getNearestUsersWithPage:(NSInteger)page
                      onSuccess:(SuccessNearestUsersBlock)success
                      onFailure:(FailureNearestUsersBlock)failure
{
    [FRDProjectFacade findNearestUsersWithPage:page onSuccess:^(NSArray *nearestUsers) {
        
        if (success) {
            success(nearestUsers);
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

@end
