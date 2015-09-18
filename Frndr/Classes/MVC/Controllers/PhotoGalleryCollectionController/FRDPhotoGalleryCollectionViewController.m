//
//  FRDPhotoGalleryCollectionViewController.m
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryCollectionViewController.h"

#import "FRDPhotoGalleryCollectionViewCell.h"

@implementation FRDPhotoGalleryCollectionViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDPhotoGalleryCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FRDPhotoGalleryCollectionViewCell class]) forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"Tutorial01"];
    return cell;
}

@end
