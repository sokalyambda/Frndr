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
#import "FRDSearchSettings.h"

//beckend keys
static NSString *const kId = @"_id";

static NSString *const kProfile = @"profile";
static NSString *const kVisible = @"visible";
static NSString *const kAge = @"age";
static NSString *const kThingsLovedMost = @"things";
static NSString *const kSexualOrientation = @"sexual";
static NSString *const kRelationshipStatus = @"relStatus";
static NSString *const kJobTitle = @"jobTitle";
static NSString *const kSmoker = @"smoker";
static NSString *const kBiography = @"bio";

static NSString *const kNotifications = @"notification";
static NSString *const kNewMessages = @"newMessages";
static NSString *const kNewFriends = @"newFriends";

@implementation FRDCurrentUserProfile

#pragma mark - Accessors

- (FRDRelationshipItem *)relationshipStatus
{
    if (!_relationshipStatus) {
        _relationshipStatus = [FRDRelationshipItem relationshipItemWithTitle:LOCALIZED(@"Single") andActiveImage:nil andNotActiveImage:nil];
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
        _sexualOrientation = [FRDSexualOrientation orientationWithOrientationString:LOCALIZED(@"Straight")];
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
        _userId = response[kId];
        
        NSDictionary *profileDict = response[kProfile];
        
        _age = [profileDict[kAge] integerValue];
        _visible = [profileDict[kVisible] boolValue];
        _thingsLovedMost = profileDict[kThingsLovedMost];
        _sexualOrientation = [FRDSexualOrientation orientationWithOrientationString:profileDict[kSexualOrientation]];
        _relationshipStatus = [FRDRelationshipItem relationshipItemWithTitle:profileDict[kRelationshipStatus] andActiveImage:@"" andNotActiveImage:@""];
        _jobTitle = profileDict[kJobTitle];
        _smoker = [profileDict[kSmoker] boolValue];
        _biography = profileDict[kBiography];
        
        NSDictionary *notificationsDict = response[kNotifications];
        _friendsNotificationsEnabled = [notificationsDict[kNewFriends] boolValue];
        _messagesNotificationsEnabled = [notificationsDict[kNewMessages] boolValue];
    }
    return self;
}

- (instancetype)updateWithUserProfile:(FRDCurrentUserProfile *)profile
{
    if (self) {
        _visible = profile.isVisible;
        _thingsLovedMost = profile.thingsLovedMost;
        _sexualOrientation = profile.sexualOrientation;
        _relationshipStatus = profile.relationshipStatus;
        _biography = profile.biography;
        _jobTitle = profile.jobTitle;
        _smoker = profile.isSmoker;
        _age = profile.age;
    }
    return self;
}

- (instancetype)initWithFacebookProfile:(FRDFacebookProfile *)profile
{
    if (self) {
        _age = profile.age;
        _fullName = profile.fullName;
        _genderString = profile.genderString;
        _avatarURL = profile.avatarURL;
    }
    return self;
}

+ (instancetype)userProfileWithFacebookProfile:(FRDFacebookProfile *)facebookProfile
{
    return [[self alloc] initWithFacebookProfile:facebookProfile];
}

@end
