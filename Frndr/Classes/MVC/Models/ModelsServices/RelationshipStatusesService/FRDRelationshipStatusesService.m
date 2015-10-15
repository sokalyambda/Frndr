//
//  FRDRelationshipStatusesService.m
//  Frndr
//
//  Created by Eugenity on 15.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRelationshipStatusesService.h"

#import "FRDNearestUser.h"
#import "FRDRelationshipItem.h"

static NSString *const kActiveImageName = @"ActiveImageName";
static NSString *const kNotActiveImageName = @"NotActiveImageName";

static NSString *const kRelationshipStatuses = @"RelationshipStatuses";
static NSString *const kFemale = @"Female";
static NSString *const kMale = @"Male";
static NSString *const kCommon = @"Common";

@implementation FRDRelationshipStatusesService

#pragma mark - Accessors

+ (NSDictionary *)femaleRelStatuses
{
    return [self generalRelStatuses][kFemale];
}

+ (NSDictionary *)maleRelStatuses
{
    return [self generalRelStatuses][kMale];
}

+ (NSDictionary *)commonRelStatuses
{
    return [self generalRelStatuses][kCommon];
}

+ (NSDictionary *)generalRelStatuses
{
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kRelationshipStatuses ofType:@"plist"]];
}

#pragma mark - Actions

+ (UIImage *)relationshipImageNameForNearestUser:(FRDNearestUser *)nearestUser
{
    NSString *activeImageName;
    NSDictionary *currentDict = nearestUser.isMale ? [self maleRelStatuses] : [self femaleRelStatuses];
    
    activeImageName = currentDict[[nearestUser.relationshipStatus.relationshipTitle capitalizedString]][kActiveImageName];
    
    return [UIImage imageNamed:activeImageName];
}

/**
 *  Create array of relationshipItems
 *
 *  @return relationshipItems
 */
+ (NSArray *)setupRelationshipsArrayWithCurrentSourceType:(FRDSourceType)sourceType
{
    NSMutableArray *currentRelStatuses = [NSMutableArray array];
    
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    
    switch (sourceType) {
        case FRDSourceTypeMyProfile: {
            
            if (currentProfile.isMale) {
                
                [[self maleRelStatuses] enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:key andActiveImage:obj[kActiveImageName] andNotActiveImage:obj[kNotActiveImageName]];
                    [currentRelStatuses addObject:item];
                }];
                
            } else {
                
                [[self femaleRelStatuses] enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:key andActiveImage:obj[kActiveImageName] andNotActiveImage:obj[kNotActiveImageName]];
                    [currentRelStatuses addObject:item];
                }];
            }
            
            break;
        }
        case FRDSourceTypeSearchSettings: {
            
            [[self commonRelStatuses] enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                
                FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:key andActiveImage:obj[kActiveImageName] andNotActiveImage:obj[kNotActiveImageName]];
                [currentRelStatuses addObject:item];
            }];
            
            break;
        }
            
        default:
            break;
    }
    
    return currentRelStatuses;
}

@end
