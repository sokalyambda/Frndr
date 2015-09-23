//
//  FRDNearestUser.h
//  Frndr
//
//  Created by Eugenity on 23.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMappingProtocol.h"

@class FRDSexualOrientation, FRDRelationshipItem;

@interface FRDNearestUser : NSObject<FRDMappingProtocol>

@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) FRDRelationshipItem *relationshipStatus;
@property (strong, nonatomic) NSString *fullName;
@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) CGFloat distanceFromMe;
@property (strong, nonatomic) FRDSexualOrientation *sexualOrientation;
@property (strong, nonatomic) NSString *jobTitle;
@property (assign, nonatomic, getter=isSmoker) BOOL smoker;
@property (strong, nonatomic) NSString *biography;
@property (strong, nonatomic) NSArray *galleryPhotos;
@property (strong, nonatomic) NSArray *thingsLovedMost;
@property (assign, nonatomic) long long userId;

@end
