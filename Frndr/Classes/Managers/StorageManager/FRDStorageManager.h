//
//  BZRStorageManager.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface FRDStorageManager : NSObject

+ (instancetype)sharedStorage;

@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *deviceUDID;
@property (strong, nonatomic) NSString *deviceName;

@end
