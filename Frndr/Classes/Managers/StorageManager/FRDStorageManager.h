//
//  BZRStorageManager.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDFacebookProfile.h"
#import "FRDCurrentUserProfile.h"

@interface FRDStorageManager : NSObject

+ (instancetype)sharedStorage;

@property (strong, nonatomic) FRDFacebookProfile *currentFacebookProfile;
@property (strong, nonatomic) FRDCurrentUserProfile *currentUserProfile;

@property (strong, nonatomic) NSString *deviceToken;
@property (nonatomic, readonly) NSString *deviceUDID;
@property (nonatomic, readonly) NSString *deviceName;

@property (assign, nonatomic, getter=isSearchSettingsUpdateNeeded) BOOL searchSettingsUpdateNeeded;
@property (assign, nonatomic, getter=isUserProfileUpdateNeeded) BOOL userProfileUpdateNeeded;
//@property (assign, nonatomic, getter=isNearestUsersUpdateNeeded) BOOL nearestUsersUpdateNeeded;

@end
