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

@interface FRDRelationshipStatusController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSArray *relationshipStatuses;

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
    currentItem.isSelected = !currentItem.isSelected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
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
    FRDRelationshipItem *relItem1 = [FRDRelationshipItem relationshipItemWithTitle:LOCALIZED(@"Single Female") andActiveImage:[UIImage imageNamed:@"SingleFemaleActiveIcon"] andNotActiveImage:[UIImage imageNamed:@"SingleFemaleNonActiveIcon"]];
    FRDRelationshipItem *relItem2 = [FRDRelationshipItem relationshipItemWithTitle:LOCALIZED(@"Single Male") andActiveImage:[UIImage imageNamed:@"SingleMaleActive"] andNotActiveImage:[UIImage imageNamed:@"SingleMaleNonActive"]];
    FRDRelationshipItem *relItem3 = [FRDRelationshipItem relationshipItemWithTitle:LOCALIZED(@"Couple") andActiveImage:[UIImage imageNamed:@"CoupleActiveIcon"] andNotActiveImage:[UIImage imageNamed:@"CoupleNonActiveIcon"]];
    FRDRelationshipItem *relItem4 = [FRDRelationshipItem relationshipItemWithTitle:LOCALIZED(@"Family") andActiveImage:[UIImage imageNamed:@"FamilyActiveIcon"] andNotActiveImage:[UIImage imageNamed:@"FamilyNonActiveIcon"]];
    FRDRelationshipItem *relItem5 = [FRDRelationshipItem relationshipItemWithTitle:LOCALIZED(@"Single Mother") andActiveImage:[UIImage imageNamed:@"SingleFemaleActiveIcon"] andNotActiveImage:[UIImage imageNamed:@"SingleFemaleNonActiveIcon"]];
    FRDRelationshipItem *relItem6 = [FRDRelationshipItem relationshipItemWithTitle:LOCALIZED(@"Single Father") andActiveImage:[UIImage imageNamed:@"SingleFatherActiveIcon"] andNotActiveImage:[UIImage imageNamed:@"SingleFatherNonActiveIcon"]];
    
    return @[relItem1, relItem2, relItem3, relItem4, relItem5, relItem6];
}

@end
