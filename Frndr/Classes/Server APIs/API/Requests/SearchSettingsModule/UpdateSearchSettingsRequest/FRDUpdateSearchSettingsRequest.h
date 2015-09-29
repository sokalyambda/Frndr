//
//  FRDUpdateSearchSettingsRequest.h
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDGetSearchSettingsRequest.h"

@class FRDSearchSettings;

@interface FRDUpdateSearchSettingsRequest : FRDGetSearchSettingsRequest

- (instancetype)initWithSearchSettingsForUpdating:(FRDSearchSettings *)searchSettingsForUpdating;

@end
