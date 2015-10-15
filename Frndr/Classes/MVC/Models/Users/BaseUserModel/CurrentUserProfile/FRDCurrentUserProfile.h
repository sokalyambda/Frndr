//
//  FRDCurrentUserProfile.h
//  Frndr
//
//  Created by Eugenity on 25.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseUserModel.h"

@class FRDSearchSettings, FRDAvatar;

@interface FRDCurrentUserProfile : FRDBaseUserModel

@property (assign, nonatomic, getter=isFriendsNotificationsEnabled) BOOL friendsNotificationsEnabled;
@property (assign, nonatomic, getter=isMessagesNotificationsEnabled) BOOL messagesNotificationsEnabled;

@property (strong, nonatomic) FRDSearchSettings *currentSearchSettings;

+ (instancetype)userProfileWithFacebookProfile:(FRDFacebookProfile *)facebookProfile;
- (instancetype)updateWithUserProfile:(FRDCurrentUserProfile *)profile;

@end
