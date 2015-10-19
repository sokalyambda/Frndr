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

@property (strong, nonatomic) FRDSexualOrientation *sexualOrientation;
@property (strong, nonatomic) NSSet *relationshipStatuses;

@property (strong, nonatomic) NSString *smokerString;

@property (assign, nonatomic) CGFloat distance;
@property (assign, nonatomic) NSInteger minAgeValue;
@property (assign, nonatomic) NSInteger maxAgeValue;
@property (strong, nonatomic) NSDictionary *ageRange;

@end
