//
//  FRDSearchSettings.m
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

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

@interface FRDSearchSettings ()

@property (strong, nonatomic) NSDictionary *ageRange;

@end

@implementation FRDSearchSettings

#pragma mark - Accessors

- (CGFloat)minAgeValue
{
    _minAgeValue = [self.ageRange[kMinAge] floatValue];
    return _minAgeValue;
}

- (CGFloat)maxAgeValue
{
    _maxAgeValue = [self.ageRange[kMaxAge] floatValue];
    return _maxAgeValue;
}

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _ageRange = response[kAgeRange];
        _sexualOrientation = [FRDSexualOrientation orientationWithOrientationString:response[kSexualOrientation]];
        _smoker = [response[kSmoker] boolValue];
        _relationshipStatuses = [NSSet setWithSet:[self relationshipStatusesFromServerResponse:response]];
        _distance = [response[kDistance] floatValue];
    }
    return self;
}

- (instancetype)updateWithServerResponse:(NSDictionary *)response
{
    if (self) {
        _ageRange = response[kAgeRange];
        _sexualOrientation = [FRDSexualOrientation orientationWithOrientationString:response[kSexualOrientation]];
        _smoker = [response[kSmoker] boolValue];
        _relationshipStatuses = [NSSet setWithSet:[self relationshipStatusesFromServerResponse:response]];
        _distance = [response[kDistance] floatValue];
    }
    return self;
}

#pragma mark - Actions

- (NSSet *)relationshipStatusesFromServerResponse:(NSDictionary *)response
{
    NSArray *relationshipStatuses = response[kRelationshipStatuses];
    NSMutableSet *tempStatuses = [NSMutableSet set];
    [relationshipStatuses enumerateObjectsUsingBlock:^(NSString  *_Nonnull statusString, NSUInteger idx, BOOL * _Nonnull stop) {
        FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:statusString andActiveImage:@"" andNotActiveImage:@""];
        [tempStatuses addObject:item];
    }];
    return tempStatuses;
}

@end
