//
//  FRDFacebookProfile.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFacebookProfile.h"

#import "FRDSexualOrientation.h"

static NSString *const kFirstName = @"first_name";
static NSString *const kLastName = @"last_name";
static NSString *const kFullName = @"name";
static NSString *const kUserId = @"id";
static NSString *const kEmail = @"email";
static NSString *const kAvatarURL = @"avatarURL";

static NSString *const kPicture = @"picture";
static NSString *const kData = @"data";
static NSString *const kURL = @"url";
static NSString *const kGender = @"gender";

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

@implementation FRDFacebookProfile

#pragma mark - Accessors

- (NSInteger)age
{
    NSDate *now = [NSDate date];
    NSDate *birthDate = self.birthDate;
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthDate
                                       toDate:now
                                       options:0.f];
    return [ageComponents year];
}

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _firstName = response[kFirstName];
        _lastName = response[kLastName];
        _fullName = response[kFullName];
        _userId = [response[kUserId] longLongValue];
        _email = response[kEmail];
        _genderString = [response[kGender] capitalizedString];
        
        _avararURL = [NSURL URLWithString:response[kPicture][kData][kURL]];
    }
    return self;
}

- (instancetype)updateWithServerResponse:(NSDictionary *)response
{
    if (self) {
        _userId = [response[kId] longLongValue];
        
        NSDictionary *profileDict   = response[kProfile];
        _visible                    = [profileDict[kVisible] boolValue];
        _thingsLovedMost            = profileDict[kThingsLovedMost];
        _chosenOrientation          = profileDict[kSexualOrientation];
        _relationshipStatus         = profileDict[kRelationshipStatus];
        _genderString               = profileDict[kSex];
        
        NSDictionary *notificationsDict = response[kNotifications];
        _friendsNotificationsEnabled = [notificationsDict[kNewFriends] boolValue];
        _messagesNotificationsEnabled = [notificationsDict[kNewMessages] boolValue];
    }
    return self;
}

#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.firstName forKey:kFirstName];
    [encoder encodeObject:self.lastName forKey:kLastName];
    [encoder encodeObject:self.email forKey:kEmail];
    [encoder encodeObject:self.fullName forKey:kFullName];
    [encoder encodeObject:@(self.userId) forKey:kUserId];
    [encoder encodeObject:self.avararURL forKey:kAvatarURL];
    [encoder encodeObject:self.genderString forKey:kGender];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        _firstName      = [decoder decodeObjectForKey:kFirstName];
        _lastName       = [decoder decodeObjectForKey:kLastName];
        _email          = [decoder decodeObjectForKey:kEmail];
        _fullName       = [decoder decodeObjectForKey:kFullName];
        _userId         = [[decoder decodeObjectForKey:kUserId] longLongValue];
        _avararURL      = [decoder decodeObjectForKey:kAvatarURL];
        _genderString   = [decoder decodeObjectForKey:kGender];
    }
    return self;
}

#pragma mark - NSUserDefaults methods

- (void)setFacebookProfileToDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        [defaults removeObjectForKey:key];
    }
    
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (FRDFacebookProfile *)facebookProfileFromDefaultsForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        return nil;
    }
    
    NSData *encodedObject = [defaults objectForKey:key];
    FRDFacebookProfile *userProfile = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return userProfile;
}


@end
