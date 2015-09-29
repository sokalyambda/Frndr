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

- (FRDRelationshipItem *)currentRelationshipStatus
{
    if (!_currentRelationshipStatus) {
        _currentRelationshipStatus = [FRDRelationshipItem relationshipItemWithTitle:@"" andActiveImage:@"" andNotActiveImage:@""];
    }
    return _currentRelationshipStatus;
}

- (NSArray *)relationshipStatuses
{
    if (!_relationshipStatuses) {
        _relationshipStatuses = [self setupRelationshipsArray];
    }
    return _relationshipStatuses;
}

- (NSInteger)selectionCounter
{
    _selectionCounter = 0;
    for (FRDRelationshipItem *item in self.relationshipStatuses) {
        if (item.isSelected) {
            _selectionCounter++;
        }
    }
    return _selectionCounter;
}

- (NSMutableSet *)relationshipStatusesForSearch
{
    if (!_relationshipStatusesForSearch) {
        _relationshipStatusesForSearch = [NSMutableSet set];
    }
    return _relationshipStatusesForSearch;
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sourceType == FRDRelationshipsDataSourceTypeMyProfile) {
        FRDRelationshipItem *currentItem = self.relationshipStatuses[indexPath.row];
        if ([currentItem isEqual:self.currentRelationshipStatus] || [self.currentRelationshipStatus.relationshipTitle isEqualToString:@""]) {
            return YES;
        }
    } else if (self.sourceType == FRDRelationshipsDataSourceTypeSearchSettings) {
        return YES;
    }
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDRelationshipItem *currentItem = self.relationshipStatuses[indexPath.row];
    FRDRelationshipCollectionCell *cell = (FRDRelationshipCollectionCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.sourceType == FRDRelationshipsDataSourceTypeMyProfile) {
        if (![currentItem isEqual:self.currentRelationshipStatus]) {
            self.currentRelationshipStatus = currentItem;
        } else {
            self.currentRelationshipStatus = nil;
        }
    } else if (self.sourceType == FRDRelationshipsDataSourceTypeSearchSettings) {
        if (![self.relationshipStatusesForSearch member:currentItem]) {
            [self.relationshipStatusesForSearch addObject:currentItem];
        } else {
            [self.relationshipStatusesForSearch removeObject:currentItem];
        }
    }
    
    [cell updateCellWithRelationshipItem:currentItem];

    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    NSLog(@"set of statuses %@", self.relationshipStatusesForSearch);
    /*
     if (!currentItem.isSelected) {
     self.selectionCounter++;
     } else if (self.selectionCounter > 0) {
     self.selectionCounter--;
     }
     
     if (self.selectionCounter < 1 || collectionView.allowsMultipleSelection) {
     
     }
     
     if (currentItem.isSelected) {
     self.selectionCounter++;
     } else if (self.selectionCounter > 0) {
     self.selectionCounter--;
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

- (void)update
{
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    NSString *relStatus = currentProfile.relationshipStatus.relationshipTitle;
    
    for (FRDRelationshipItem *item in self.relationshipStatuses) {
        if ([item.relationshipTitle isEqualToString:relStatus] || [item.relationshipTitle.lowercaseString containsString:relStatus]) {
            self.currentRelationshipStatus = item;
            self.currentRelationshipStatus.isSelected = YES;
            break;
        }
    }
    if (self.currentRelationshipStatus) {
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.relationshipStatuses indexOfObject:self.currentRelationshipStatus] inSection:0]]];
        NSInteger idx = [self.relationshipStatuses indexOfObject:self.currentRelationshipStatus];
        if (idx != NSNotFound) {
           [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}

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
