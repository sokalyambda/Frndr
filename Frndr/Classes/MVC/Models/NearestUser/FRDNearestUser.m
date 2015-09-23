//
//  FRDNearestUser.m
//  Frndr
//
//  Created by Eugenity on 23.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNearestUser.h"

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
/*
 @property (assign, nonatomic) NSInteger age;
 @property (strong, nonatomic) NSURL *avatarURL;
 @property (strong, nonatomic) NSString *biography;
 @property (assign, nonatomic) CGFloat distanceFromMe;
 @property (strong, nonatomic) NSArray *galleryPhotos;
 @property (strong, nonatomic) NSString *jobTitle;
 @property (strong, nonatomic) NSArray *thingsLovedMost;
 @property (strong, nonatomic) NSString *fullName;
 @property (strong, nonatomic) FRDSexualOrientation *sexualOrientation;
 @property (strong, nonatomic) FRDRelationshipItem *relationshipStatus;
 @property (assign, nonatomic, getter=isSmoker) BOOL smoker;
 id
 */
#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _age = [response[kAge] integerValue];
        _avatarURL = [NSURL URLWithString:response[kAvatarURL]];
        _biography = response[kBiography];
        _distanceFromMe = [response[kDistance] floatValue];
        
    }
    return self;
}

@end
