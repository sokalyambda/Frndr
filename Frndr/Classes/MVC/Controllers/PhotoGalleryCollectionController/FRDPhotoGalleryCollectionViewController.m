//
//  FRDPhotoGalleryCollectionViewController.m
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryCollectionViewController.h"

#import "FRDPhotoGalleryCollectionViewCell.h"

static CGFloat const space = 2.f;

@implementation FRDPhotoGalleryCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat bigRectSize = self.view.frame.size.width * (2.0 / 3.0) - space;
//    CGFloat smallRectSize = self.view.frame.size.width  * (1.0 / 3.0) - space;
    
//    if (indexPath.item == 0) {
//        return CGSizeMake(bigRectSize, bigRectSize);
//    }
//    else {
//        return CGSizeMake(smallRectSize, smallRectSize);
//    }
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return space;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDPhotoGalleryCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FRDPhotoGalleryCollectionViewCell class]) forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"tutorial01"];
    return cell;
}

#pragma mark - Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
