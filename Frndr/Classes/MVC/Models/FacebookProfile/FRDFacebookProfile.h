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

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSURL *avararURL;
@property (strong, nonatomic) NSString *genderString;
@property (nonatomic) long long userId;

@property (nonatomic, getter=isVisible) BOOL visible;
@property (strong, nonatomic) NSString *biography;
@property (strong, nonatomic) NSArray *thingsLovedMost;
@property (strong, nonatomic) FRDSexualOrientation *chosenOrientation;
@property (nonatomic, getter=isSmoker) BOOL smoker;
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSString *relationshipStatus;

@property (strong, nonatomic) NSDate *birthDate;
@property (nonatomic, readonly) NSInteger age;

@property (nonatomic, getter=isMessagesNotificationsEnabled) BOOL messagesNotificationsEnabled;
@property (nonatomic, getter=ifFriendsNotificationsEnabled) BOOL friendsNotificationsEnabled;

- (void)setFacebookProfileToDefaultsForKey:(NSString *)key;
+ (FRDFacebookProfile *)facebookProfileFromDefaultsForKey:(NSString *)key;

@end
