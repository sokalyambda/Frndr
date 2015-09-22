//
//  FRDFacebookProfile.h
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMappingProtocol.h"

@class FRDSexualOrientation;

@interface FRDFacebookProfile : NSObject<FRDMappingProtocol>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *fullName;

@property (nonatomic) NSString *email;
@property (nonatomic) NSURL *avararURL;
@property (nonatomic) NSString *genderString;
@property (nonatomic) long long userId;

@property (nonatomic, getter=isVisible) BOOL visible;
@property (nonatomic) NSString *biography;
@property (nonatomic) NSArray *thingsLovedMost;
@property (nonatomic) FRDSexualOrientation *chosenOrientation;
@property (nonatomic, getter=isSmoker) BOOL smoker;
@property (nonatomic) NSString *jobTitle;
@property (nonatomic) NSString *relationshipStatus;

@property (nonatomic) NSDate *birthDate;
@property (nonatomic, readonly) NSInteger age;

@property (nonatomic, getter=isMessagesNotificationsEnabled) BOOL messagesNotificationsEnabled;
@property (nonatomic, getter=ifFriendsNotificationsEnabled) BOOL friendsNotificationsEnabled;

- (void)setFacebookProfileToDefaultsForKey:(NSString *)key;
+ (FRDFacebookProfile *)facebookProfileFromDefaultsForKey:(NSString *)key;

@end
