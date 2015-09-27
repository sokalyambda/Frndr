//
//  FRDRelationshipStatusController.h
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSUInteger, FRDRelationshipsDataSourceType) {
    FRDRelationshipsDataSourceTypeSearchSettings,
    FRDRelationshipsDataSourceTypeMyProfile
};

#import "FRDBaseViewController.h"

@interface FRDRelationshipStatusController : FRDBaseViewController

@property (nonatomic) FRDRelationshipsDataSourceType sourceType;

@end
