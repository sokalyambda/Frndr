//
//  FRDUpdateSearchSettingsRequest.m
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDUpdateSearchSettingsRequest.h"

#import "FRDSearchSettings.h"
#import "FRDSexualOrientation.h"
#import "FRDRelationshipItem.h"

static NSString *const kAgeRange                = @"ageRange";
static NSString *const kMaxAge                  = @"max";
static NSString *const kMinAge                  = @"min";
static NSString *const kSexualOrientation       = @"sexual";
static NSString *const kSmoker                  = @"smoker";
static NSString *const kRelationshipStatuses    = @"relationship";
static NSString *const kDistance                = @"distance";

@implementation FRDUpdateSearchSettingsRequest

#pragma mark - Lifecycle

- (instancetype)initWithSearchSettingsForUpdating:(FRDSearchSettings *)searchSettingsForUpdating
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"PUT";
        
        NSMutableDictionary *parameters = [@{kAgeRange: @{kMinAge: @(searchSettingsForUpdating.minAgeValue),
                                                          kMaxAge: @(searchSettingsForUpdating.maxAgeValue)},
                                             kSexualOrientation: searchSettingsForUpdating.sexualOrientation.orientationString,
                                             kSmoker: @(searchSettingsForUpdating.isSmoker),
                                             kRelationshipStatuses: [self relationsipStatusesForUpdatingFromSearchSettings:searchSettingsForUpdating],
                                             kDistance: @(searchSettingsForUpdating.distance)
                                             } mutableCopy];
        
        self.serializationType = FRDRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

#pragma mark - Actions

- (NSArray *)relationsipStatusesForUpdatingFromSearchSettings:(FRDSearchSettings *)searchSettings
{
    NSMutableArray *statusesForSending = [@[] mutableCopy];
    
    [searchSettings.relationshipStatuses enumerateObjectsUsingBlock:^(FRDRelationshipItem  *_Nonnull relItem, BOOL * _Nonnull stop) {
        [statusesForSending addObject:relItem.relationshipTitle];
    }];
    return [NSArray arrayWithArray:statusesForSending];
}

@end