//
//  FRDPreviewGalleryController.m
//  Frndr
//
//  Created by Eugenity on 18.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPreviewGalleryController.h"

#import "FRDPreviewPhotoCell.h"

#import "UIView+MakeFromXib.h"

@interface FRDPreviewGalleryController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;

@property (nonatomic) NSArray *photos;

@end

@implementation FRDPreviewGalleryController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerCell];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.photos.count;
#warning temporary!
    return 10.f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDPreviewPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FRDPreviewPhotoCell class]) forIndexPath:indexPath];
    
    if (!cell) {
        cell = [FRDPreviewPhotoCell makeFromXib];
    }
    
    cell.photoImageView.image = [UIImage imageNamed:@"Tutorial01"];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

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
    NSString *nibName = NSStringFromClass([FRDPreviewPhotoCell class]);
    UINib *cellNib = [UINib nibWithNibName:nibName bundle:nil];
    [self.photosCollectionView registerNib:cellNib forCellWithReuseIdentifier:nibName];
}

@end
