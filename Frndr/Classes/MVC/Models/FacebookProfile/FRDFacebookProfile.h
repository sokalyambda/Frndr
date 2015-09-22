//
//  FRDFacebookProfile.h
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMappingProtocol.h"

@interface FRDFacebookProfile : NSObject<FRDMappingProtocol>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSURL *avararURL;
@property (nonatomic) NSString *genderString;
@property (nonatomic) long long userId;

@property (nonatomic, getter=isVisible) BOOL visible;

- (void)setFacebookProfileToDefaultsForKey:(NSString *)key;
+ (FRDFacebookProfile *)facebookProfileFromDefaultsForKey:(NSString *)key;

@end
