//
//  FRDGetSearchSettingsRequest.h
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@class FRDSearchSettings;

@interface FRDGetSearchSettingsRequest : FRDNetworkRequest

@property (strong, nonatomic) FRDSearchSettings *currentSearchSettings;

- (NSString *)requestAction;

@end
