//
//  FRDSearchSettings.h
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMappingProtocol.h"

@class FRDSexualOrientation;

@interface FRDSearchSettings : NSObject<FRDMappingProtocol>

@property (strong, nonatomic) NSDictionary *ageRange;
@property (strong, nonatomic) FRDSexualOrientation *sexualOrientation;
@property (strong, nonatomic) NSSet *relationshipStatuses;
@property (assign, nonatomic, getter=isSmoker) BOOL smoker;
@property (assign, nonatomic) CGFloat distance;

@end
