//
//  FRDBaseUserModel.m
//  Frndr
//
//  Created by Eugenity on 25.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseUserModel.h"

#import "FRDSexualOrientation.h"
#import "FRDRelationshipItem.h"
#import "FRDAvatar.h"

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
static NSString *const kSex                 = @"sex";

@implementation FRDBaseUserModel

#pragma mark - Accessors

- (FRDAvatar *)currentAvatar
{
    if (!_currentAvatar) {
        _currentAvatar = [[FRDAvatar alloc] init];
    }
    return _currentAvatar;
}

- (BOOL)isMale
{
    if ([self.genderString isEqualToString:@"Male"]) {
        return YES;
    }
    return NO;
}

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
        _sexualOrientation = [FRDSexualOrientation orientationWithOrientationString:response[kSexualOrientation]];
        /*
         _relationshipStatus = [[FRDRelationshipItem alloc] init];
         */
        _genderString = response[kSex];
        _smoker = [response[kSmoker] boolValue];
        _userId = response[kUserId];
    }
    return self;
}

@end
