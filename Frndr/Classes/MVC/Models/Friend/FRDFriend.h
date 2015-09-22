//
//  FRDFriend.h
//  Frndr
//
//  Created by Eugenity on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMappingProtocol.h"

@interface FRDFriend : NSObject<FRDMappingProtocol>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic, readonly) NSString *fullName;

@property (nonatomic) long long friendId;
@property (nonatomic) NSString *lastMessage;
@property (nonatomic) NSString *avatarURL;

@property (nonatomic) CGFloat distanceFromMe;
@property (nonatomic) BOOL smoker;
@property (nonatomic) NSUInteger age;

@end
