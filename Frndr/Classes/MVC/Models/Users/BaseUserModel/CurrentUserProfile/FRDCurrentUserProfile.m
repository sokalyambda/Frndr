//
//  FRDCurrentUserProfile.m
//  Frndr
//
//  Created by Eugenity on 25.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDCurrentUserProfile.h"

#import "FRDSexualOrientation.h"
#import "FRDRelationshipItem.h"

//beckend keys
static NSString *const kId = @"_id";

static NSString *const kProfile = @"profile";
static NSString *const kVisible = @"visible";
static NSString *const kThingsLovedMost = @"things";
static NSString *const kSexualOrientation = @"sexual";
static NSString *const kRelationshipStatus = @"relStatus";
static NSString *const kSex = @"sex";

static NSString *const kNotifications = @"notification";
static NSString *const kNewMessages = @"newMessages";
static NSString *const kNewFriends = @"newFriends";

/*
 "coordinates": [15, 25],
 "profile": {
 "name": "Petrovich",
 "age": "25",
 "relStatus": "single",
 "jobTitle": "Doctor",
 "smoker": "true",
 "sexual": "straight",
 "things": ["tennis", "box", "cars"],
 "bio": "Some biography",
 "visible": "true",
 "sex": "M"
 }
 */

@implementation FRDCurrentUserProfile

#pragma mark - Accessors

- (FRDRelationshipItem *)relationshipStatus
{
    if (!_relationshipStatus) {
        _relationshipStatus = [FRDRelationshipItem relationshipItemWithTitle:@"Single" andActiveImage:nil andNotActiveImage:nil];
    }
    return _relationshipStatus;
}

- (NSString *)jobTitle
{
    if (!_jobTitle) {
        _jobTitle = @"";
    }
    return _jobTitle;
}

- (FRDSexualOrientation *)sexualOrientation
{
    if (!_sexualOrientation) {
        _sexualOrientation = [[FRDSexualOrientation alloc] initWithOrientationString:@"straight"];
    }
    return _sexualOrientation;
}

- (NSArray *)thingsLovedMost
{
    if (!_thingsLovedMost) {
        _thingsLovedMost = @[];
    }
    return _thingsLovedMost;
}

- (NSString *)biography
{
    if (!_biography) {
        _biography = @"";
    }
    return _biography;
}

#pragma mark - FRDMappingProtocol

- (instancetype)updateWithServerResponse:(NSDictionary *)response
{
    if (self) {
//        _userId = [response[kId] longLongValue];
        
        NSDictionary *profileDict   = response[kProfile];
        _visible                    = [profileDict[kVisible] boolValue];
//        _chosenOrientation          = profileDict[kSexualOrientation];
//        _genderString               = profileDict[kSex];
        
        NSDictionary *notificationsDict = response[kNotifications];
        _friendsNotificationsEnabled = [notificationsDict[kNewFriends] boolValue];
        _messagesNotificationsEnabled = [notificationsDict[kNewMessages] boolValue];
    }
    return self;
}

- (instancetype)initWithFacebookProfile:(FRDFacebookProfile *)profile
{
    if (self) {
        _age = profile.age;
        _fullName = profile.fullName;
        _genderString = profile.genderString;
    }
    return self;
}

+ (instancetype)userProfileWithFacebookProfile:(FRDFacebookProfile *)facebookProfile
{
    return [[self alloc] initWithFacebookProfile:facebookProfile];
}

@end
