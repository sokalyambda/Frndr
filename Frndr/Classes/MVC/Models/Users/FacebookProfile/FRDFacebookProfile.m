//
//  FRDFacebookProfile.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFacebookProfile.h"

#import "FRDCommonDateFormatter.h"

//facebook keys
static NSString *const kFirstName = @"first_name";
static NSString *const kLastName = @"last_name";
static NSString *const kFullName = @"name";
static NSString *const kUserId = @"id";
static NSString *const kEmail = @"email";
static NSString *const kAvatarURL = @"avatarURL";
static NSString *const kBirthDate = @"birthday";

static NSString *const kPicture = @"picture";
static NSString *const kData = @"data";
static NSString *const kURL = @"url";
static NSString *const kGender = @"gender";

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

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *)firstName
{
    if (!_firstName) {
        _firstName = @"";
    }
    return _firstName;
}

- (NSString *)lastName
{
    if (!_lastName) {
        _lastName = @"";
    }
    return _lastName;
}

- (NSString *)email
{
    if (!_email) {
        _email = @"";
    }
    return _email;
}

- (NSString *)genderString
{
    if (!_genderString) {
        _genderString = @"Male";
    }
    return _genderString;
}

- (NSDate *)birthDate
{
    if (!_birthDate) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setYear:0.f];
        _birthDate = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    }
    return _birthDate;
}

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _firstName = response[kFirstName];
        _lastName = response[kLastName];

        _facebookUserId = [response[kUserId] longLongValue];
        _email = response[kEmail];
        _genderString = [response[kGender] capitalizedString];
        _birthDate = [[FRDCommonDateFormatter commonDateFormatter] dateFromString:response[kBirthDate]];
        
        _avatarURL = [NSURL URLWithString:response[kPicture][kData][kURL]];
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
    [encoder encodeObject:@(self.facebookUserId) forKey:kUserId];
    [encoder encodeObject:self.avatarURL forKey:kAvatarURL];
    [encoder encodeObject:self.genderString forKey:kGender];
    [encoder encodeObject:self.birthDate forKey:kBirthDate];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        _firstName      = [decoder decodeObjectForKey:kFirstName];
        _lastName       = [decoder decodeObjectForKey:kLastName];
        _email          = [decoder decodeObjectForKey:kEmail];
        _facebookUserId = [[decoder decodeObjectForKey:kUserId] longLongValue];
        _avatarURL      = [decoder decodeObjectForKey:kAvatarURL];
        _genderString   = [decoder decodeObjectForKey:kGender];
        _birthDate      = [decoder decodeObjectForKey:kBirthDate];
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
