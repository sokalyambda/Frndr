//
//  FRDNearestUsersService.m
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNearestUsersService.h"

#import "FRDProjectFacade.h"

static NSString *const kSuccessKey = @"success";
static NSString *const kFailureKey = @"failure";

@implementation FRDNearestUsersService

static BOOL _isSearchInProcess = NO;
static NSTimer *_searchTimer;

#pragma mark - Accessors

+ (BOOL)isSearchInProcess
{
    @synchronized(self) {
        return _isSearchInProcess;
    }
}

+ (void)setSearchInProcess:(BOOL)searchInProcess
{
    @synchronized(self) {
        _isSearchInProcess = searchInProcess;
    }
}

+ (NSTimer *)searchTimer
{
    @synchronized(self) {
        return _searchTimer;
    }
}

+ (void)setSearchTimer:(NSTimer *)searchTimer
{
    @synchronized(self) {
        _searchTimer = searchTimer;
    }
}

#pragma mark - Actions

+ (void)getNearestUsersWithPage:(NSInteger)page
                      onSuccess:(SuccessNearestUsersBlock)success
                      onFailure:(FailureNearestUsersBlock)failure
{
    WEAK_SELF;
    [FRDProjectFacade findNearestUsersWithPage:page onSuccess:^(NSArray *nearestUsers) {
        
        if (success) {
            success(nearestUsers);
        }
        
        if (!nearestUsers.count && ![weakSelf isSearchInProcess]) {
            [weakSelf scheduleTimerForFriendsSearchOnSuccess:success onFailure:failure];
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (void)scheduleTimerForFriendsSearchOnSuccess:(SuccessNearestUsersBlock)success onFailure:(FailureNearestUsersBlock)failure
{
    [self setSearchInProcess:YES];
    [self setSearchTimer:[NSTimer scheduledTimerWithTimeInterval:30.f
                                                          target:self
                                                        selector:@selector(findNearestFriendsWithTimer:)
                                                        userInfo:@{kSuccessKey: success,
                                                                   kFailureKey: failure
                                                                   } repeats:YES]];
}

+ (void)findNearestFriendsWithTimer:(NSTimer *)timer
{
    SuccessNearestUsersBlock success = timer.userInfo[kSuccessKey];
    FailureNearestUsersBlock failure = timer.userInfo[kFailureKey];
    
    WEAK_SELF;
    [self getNearestUsersWithPage:1 onSuccess:^(NSArray *nearestUsers) {
        
        if (nearestUsers.count) {
            [timer invalidate];
            [weakSelf setSearchInProcess:NO];
        }
        
        if (success) {
            success(nearestUsers);
        }
        
    } onFailure:^(NSError *error) {
        
        [timer invalidate];
        [weakSelf setSearchInProcess:NO];
        
        if (failure) {
            failure(error);
        }
        
    }];
}

@end
