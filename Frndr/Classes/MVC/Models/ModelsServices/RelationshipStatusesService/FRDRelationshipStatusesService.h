//
//  FRDRelationshipStatusesService.h
//  Frndr
//
//  Created by Eugenity on 15.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseViewController.h"

@class FRDNearestUser;

@interface FRDRelationshipStatusesService : NSObject

+ (UIImage *)relationshipImageNameForNearestUser:(FRDNearestUser *)nearestUser;

+ (NSArray *)setupRelationshipsArrayWithCurrentSourceType:(FRDSourceType)sourceType;

@end
