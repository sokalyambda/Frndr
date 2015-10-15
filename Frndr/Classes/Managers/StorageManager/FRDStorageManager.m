//
//  BZRStorageManager.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDStorageManager.h"

#import "FRDRemoteNotification.h"

@interface FRDStorageManager ()

@end

@implementation FRDStorageManager

@synthesize deviceName = _deviceName, deviceUDID = _deviceUDID;

#pragma mark - Accessors

- (FRDFacebookProfile *)currentFacebookProfile
{
    if (!_currentFacebookProfile) {
        _currentFacebookProfile = [FRDFacebookProfile facebookProfileFromDefaultsForKey:FBCurrentProfile];
    }
    return _currentFacebookProfile;
}

- (NSString *)deviceUDID
{
    _deviceUDID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    return _deviceUDID;
}

- (NSString *)deviceName
{
    _deviceName = [UIDevice currentDevice].name;
    return _deviceName;
}

#pragma mark - Lifecycle

+ (instancetype)sharedStorage
{
    static FRDStorageManager *storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[FRDStorageManager alloc] init];
    });
    return storage;
}

@end
