//
//  BZRStorageManager.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDFacebookProfile.h"

@interface FRDStorageManager : NSObject

+ (instancetype)sharedStorage;

@property (strong, nonatomic) FRDFacebookProfile *currentFacebookProfile;

@property (strong, nonatomic) NSString *deviceToken;
@property (nonatomic, readonly) NSString *deviceUDID;
@property (nonatomic, readonly) NSString *deviceName;

@end
