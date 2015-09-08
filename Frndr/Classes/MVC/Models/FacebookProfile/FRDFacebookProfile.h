//
//  FRDFacebookProfile.h
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMappingProtocol.h"

@interface FRDFacebookProfile : NSObject<FRDMappingProtocol>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSURL *avararURL;
@property (strong, nonatomic) NSString *genderString;
@property (assign, nonatomic) long long userId;

- (void)setFacebookProfileToDefaultsForKey:(NSString *)key;
+ (FRDFacebookProfile *)facebookProfileFromDefaultsForKey:(NSString *)key;

@end
