//
//  FRDNearestUser.m
//  Frndr
//
//  Created by Eugenity on 23.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNearestUser.h"

#import "FRDSexualOrientation.h"
#import "FRDRelationshipItem.h"

static NSString *const kAge                 = @"age";
static NSString *const kAvatarURL           = @"avatar";
static NSString *const kBiography           = @"bio";
static NSString *const kDistance            = @"distance";
static NSString *const kGallery             = @"gallery";
static NSString *const kJobTitle            = @"jobTitle";
static NSString *const kThingsLovedMost     = @"likes";
static NSString *const kName                = @"name";
static NSString *const kSexualOrientation   = @"sexual";
static NSString *const kSmoker              = @"smoker";
static NSString *const kUserId              = @"userId";

@implementation FRDNearestUser

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _age = [response[kAge] integerValue];
        _avatarURL = [NSURL URLWithString:response[kAvatarURL]];
        _biography = response[kBiography];
        _distanceFromMe = [response[kDistance] floatValue];
        _galleryPhotos = response[kGallery];
        _jobTitle = response[kJobTitle];
        _thingsLovedMost = response[kThingsLovedMost];
        _fullName = response[kName];
        _sexualOrientation = [[FRDSexualOrientation alloc] initWithOrientationString:response[kSexualOrientation]];
        /*
        _relationshipStatus = [[FRDRelationshipItem alloc] init];
        */
        _smoker = [response[kSmoker] boolValue];
        _userId = [response[kUserId] longLongValue];
    }
    return self;
}

@end