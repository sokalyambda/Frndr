//
//  FRDCurrentUserProfile.h
//  Frndr
//
//  Created by Eugenity on 25.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseUserModel.h"

@interface FRDCurrentUserProfile : FRDBaseUserModel

@property (assign, nonatomic, getter=isVisible) BOOL visible;

@property (assign, nonatomic, getter=isFriendsNotificationsEnabled) BOOL friendsNotificationsEnabled;
@property (assign, nonatomic, getter=isMessagesNotificationsEnabled) BOOL messagesNotificationsEnabled;

+ (instancetype)userProfileWithFacebookProfile:(FRDFacebookProfile *)facebookProfile;
- (instancetype)updateWithUserProfile:(FRDCurrentUserProfile *)profile;

@end
