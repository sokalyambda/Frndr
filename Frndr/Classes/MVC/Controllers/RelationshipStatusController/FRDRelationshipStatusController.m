//
//  FRDRelationshipStatusController.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRelationshipStatusController.h"

#import "FRDRelationshipItem.h"

#import "FRDRelationshipCollectionCell.h"

#import "UIView+MakeFromXib.h"

static NSString *const kActiveImageName = @"ActiveImageName";
static NSString *const kNotActiveImageName = @"NotActiveImageName";

@interface FRDRelationshipStatusController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSArray *relationshipStatuses;

@property (nonatomic) NSInteger selectionCounter;

@end

@implementation FRDRelationshipStatusController

#pragma mark - Accessors

- (NSArray *)relationshipStatuses
{
    if (!_relationshipStatuses) {
        _relationshipStatuses = [self setupRelationshipsArray];
    }
    return _relationshipStatuses;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerCell];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.relationshipStatuses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDRelationshipCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FRDRelationshipCollectionCell class]) forIndexPath:indexPath];
    
    if (!cell) {
        cell = [FRDRelationshipCollectionCell makeFromXib];
    }
    
    FRDRelationshipItem *currentItem = self.relationshipStatuses[indexPath.row];
    
    [cell configureCellWithRelationshipItem:currentItem];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDRelationshipItem *currentItem = self.relationshipStatuses[indexPath.row];
    FRDRelationshipCollectionCell *cell = (FRDRelationshipCollectionCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    [cell updateCellWithRelationshipItem:currentItem];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    /*
    if (!currentItem.isSelected) {
        self.selectionCounter++;
    } else if (self.selectionCounter > 0) {
        self.selectionCounter--;
    }
    
    if (self.selectionCounter < 1 || collectionView.allowsMultipleSelection) {
        
    }
     */
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    CGFloat height = CGRectGetHeight(collectionView.bounds);
    CGFloat width = height;

    size = CGSizeMake(width, height);
    return size;
}

#pragma mark - Actions

/**
 *  Register custom cell's class
 */
- (void)registerCell
{
    NSString *nibName = NSStringFromClass([FRDRelationshipCollectionCell class]);
    UINib *cellNib = [UINib nibWithNibName:nibName bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:nibName];
}

/**
 *  Create array of relationshipItems
 *
 *  @return relationshipItems
 */
- (NSArray *)setupRelationshipsArray
{
    
    NSDictionary *relDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RelationshipStatuses" ofType:@"plist"]];
    NSDictionary *commonRelStatuses = relDict[@"Common"];
    NSDictionary *femaleRelStatuses = relDict[@"Female"];
    NSDictionary *maleRelStatuses = relDict[@"Male"];
    
    NSMutableArray *currentRelStatuses = [NSMutableArray array];
    
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    
    switch (self.sourceType) {
        case FRDRelationshipsDataSourceTypeMyProfile: {
            
            self.collectionView.allowsMultipleSelection = NO;
            
            [commonRelStatuses enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                
                FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:key andActiveImage:obj[kActiveImageName] andNotActiveImage:obj[kNotActiveImageName]];
                [currentRelStatuses addObject:item];
            }];
            
            if (currentProfile.isMale) {
                
                [maleRelStatuses enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:key andActiveImage:obj[kActiveImageName] andNotActiveImage:obj[kNotActiveImageName]];
                    [currentRelStatuses addObject:item];
                }];
                
            } else {
                
                [femaleRelStatuses enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:key andActiveImage:obj[kActiveImageName] andNotActiveImage:obj[kNotActiveImageName]];
                    [currentRelStatuses addObject:item];
                }];
                
            }
            
            break;
        }
        case FRDRelationshipsDataSourceTypeSearchSettings: {
            
            self.collectionView.allowsMultipleSelection = YES;
            
            [maleRelStatuses enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                
                FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:key andActiveImage:obj[kActiveImageName] andNotActiveImage:obj[kNotActiveImageName]];
                [currentRelStatuses addObject:item];
            }];
            [commonRelStatuses enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                
                FRDRelationshipItem *item = [FRDRelationshipItem relationshipItemWithTitle:key andActiveImage:obj[kActiveImageName] andNotActiveImage:obj[kNotActiveImageName]];
                [currentRelStatuses addObject:item];
            }];
            [femaleRelStatuses enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSDictionary  * _Nonnull obj, BOOL * _Nonnull stop) {
                
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
