//
//  FRDFriend.m
//  Frndr
//
//  Created by Eugenity on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriend.h"
#import "FRDRelationshipItem.h"
#import "FRDGalleryPhoto.h"
#import "FRDAvatar.h"

#import "FRDCommonDateFormatter.h"
#import "ISO8601DateFormatter.h"

static NSString *const kNewFriend = @"newFriend";
static NSString *const kLastMessage = @"message";
static NSString *const kFriendId = @"friendId";
static NSString *const kLastMessagePostedDate = @"date";
static NSString *const kMostLovedThings = @"things";

static NSString *const kProfileDict = @"profile";
static NSString *const kFriendIdKey = @"_id";
static NSString *const kImages = @"images";
static NSString *const kAvatar = @"avatar";
static NSString *const kGallery = @"gallery";
static NSString *const kVisible = @"visible";
static NSString *const kRelationshipStatus = @"relStatus";
static NSString *const kGenderString = @"sex";
static NSString *const kAvatarURL = @"url";

//push notifications keys
static NSString *const kFriendAvatarURL = @"avatarUrl";
static NSString *const kFriendName = @"friendName";

static NSString *const kHasNewMessages = @"haveNewMsg";

@implementation FRDFriend

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super initWithServerResponse:response];
    if (self) {
        _userId = response[kFriendId];
        _newFriend = [response[kNewFriend] boolValue];
        _lastMessage = response[kLastMessage];
        _lastMessagePostedDate = [[FRDCommonDateFormatter commonISO8601DateFormatter] dateFromString:response[kLastMessagePostedDate]];
        
        //messages
        _hasNewMessages = [response[kHasNewMessages] boolValue];
    }
    return self;
}

- (instancetype)initFullFriendProfileWithServerResponse:(NSDictionary *)response
{
    self = [super initWithServerResponse:response[kProfileDict]];
    
    if (self) {
        //profile
        _genderString = response[kProfileDict][kGenderString];
        _visible = [response[kProfileDict][kVisible] boolValue];
        _relationshipStatus = [FRDRelationshipItem relationshipItemWithTitle:response[kProfileDict][kRelationshipStatus] andActiveImage:@"" andNotActiveImage:@""];
        
        //messages
        _hasNewMessages = [response[kHasNewMessages] boolValue];
        
        //images
        _currentAvatar = [[FRDAvatar alloc] initWithServerResponse:response[kImages][kAvatar]];
        _galleryPhotos = [self photosFromArray:response[kImages][kGallery]];
        
        //there is difference in keys
        _userId = response[kFriendIdKey];
        
        //things that he loves most
        _thingsLovedMost = response[kProfileDict][kMostLovedThings];
    }
    
    return self;
}

- (instancetype)initWithPushNotificationUserInfo:(NSDictionary *)userInfo
{
    self = [super init];
    
    if (self) {
        _userId = userInfo[kFriendId];
        _avatarURL = userInfo[kFriendAvatarURL];
        _fullName = userInfo[kFriendName];
    }
    return self;
}

//Get gallery photos
- (NSArray *)photosFromArray:(NSArray *)photosArray
{
    NSMutableArray *gallery = [NSMutableArray array];
    for (NSDictionary *dict in photosArray) {
        FRDGalleryPhoto *photo = [[FRDGalleryPhoto alloc] initWithServerResponse:dict];
        [gallery addObject:photo];
    }
    
    return [NSArray arrayWithArray:gallery];
}

@end
