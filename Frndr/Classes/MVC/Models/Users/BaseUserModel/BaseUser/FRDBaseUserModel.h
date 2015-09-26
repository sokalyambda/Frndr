//
//  FRDBaseUserModel.h
//  Frndr
//
//  Created by Eugenity on 25.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMappingProtocol.h"

@class FRDSexualOrientation, FRDRelationshipItem;

@interface FRDBaseUserModel : NSObject<FRDMappingProtocol> {
    @protected
    FRDRelationshipItem *_relationshipStatus;
    FRDSexualOrientation *_sexualOrientation;
    NSString *_jobTitle;
    NSString *_biography;
    NSArray *_thingsLovedMost;
    NSInteger _age;
    NSString *_fullName;
    NSString *_genderString;
    BOOL _smoker;
    long long _userId;
}

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSURL *avatarURL;

@property (strong, nonatomic) FRDRelationshipItem *relationshipStatus;
@property (strong, nonatomic) FRDSexualOrientation *sexualOrientation;

@property (strong, nonatomic) NSString *genderString;
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSString *biography;
@property (strong, nonatomic) NSArray *galleryPhotos;
@property (strong, nonatomic) NSArray *thingsLovedMost;

@property (assign, nonatomic) long long userId;
@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) CGFloat distanceFromMe;
@property (assign, nonatomic, getter=isSmoker) BOOL smoker;

@end
