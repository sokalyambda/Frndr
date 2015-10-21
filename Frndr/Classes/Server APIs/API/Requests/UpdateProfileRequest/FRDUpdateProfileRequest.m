//
//  FRDUpdateProfileRequest.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDUpdateProfileRequest.h"

#import "FRDLocationObserver.h"

#import "FRDSexualOrientation.h"
#import "FRDRelationshipItem.h"

static NSString *const requestAction = @"users";

static NSString *const kCoordinates = @"coordinates";
static NSString *const kProfile = @"profile";

static NSString *const kName                = @"name";
static NSString *const kAge                 = @"age";
static NSString *const kRelationshipStatus  = @"relStatus";
static NSString *const kJobTitle            = @"jobTitle";
static NSString *const kSmoker              = @"smoker";
static NSString *const kSexualOrientation   = @"sexual";
static NSString *const kThingsLovedMost     = @"things";
static NSString *const kBiography           = @"bio";
static NSString *const kVisible             = @"visible";
static NSString *const kGender              = @"sex";

@interface FRDUpdateProfileRequest ()

@property (strong, nonatomic) FRDCurrentUserProfile *profileForUpdating;

@end

@implementation FRDUpdateProfileRequest

#pragma mark - Lifecycle

- (instancetype)initWithUpdatedProfile:(FRDCurrentUserProfile *)updatedProfile
{
    self = [super init];
    if (self) {
        _profileForUpdating = updatedProfile;
        
        self.action = [self requestAction];
        _method = @"PUT";
        
        CLLocation *currentLocation = [FRDLocationObserver sharedObserver].currentLocation;
        NSArray *coords = @[@(currentLocation.coordinate.longitude), @(currentLocation.coordinate.latitude)];

        NSDictionary *profile = @{
                                  
                                  kName:                updatedProfile.fullName,
                                  kAge:                 @(updatedProfile.age),
                                  kRelationshipStatus:  updatedProfile.relationshipStatus.relationshipTitle,
                                  kJobTitle:            updatedProfile.jobTitle,
                                  kSmoker:              @(updatedProfile.isSmoker),
                                  kSexualOrientation:   updatedProfile.sexualOrientation.orientationString,
                                  kThingsLovedMost:     updatedProfile.thingsLovedMost,
                                  kBiography:           updatedProfile.biography,
                                  kVisible:             @(updatedProfile.isVisible),
                                  kGender:              updatedProfile.genderString
                                  
                                  };
        
        NSMutableDictionary *parameters = [@{
                                             kCoordinates: coords,
                                             kProfile: profile
                                             } mutableCopy];
        
        self.serializationType = FRDRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    self.confirmedProfile = self.profileForUpdating;
    return !!self.confirmedProfile;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
