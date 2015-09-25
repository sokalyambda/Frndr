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

@end

@implementation FRDPreviewGalleryController

#pragma mark - Accessors

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.photosCollectionView reloadData];
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
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDPreviewPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FRDPreviewPhotoCell class]) forIndexPath:indexPath];
    
    if (!cell) {
        cell = [FRDPreviewPhotoCell makeFromXib];
    }
    
    NSURL *currentPhotoURL = self.photos[indexPath.row];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:cell animated:YES];
    hud.color = [[UIColor clearColor] copy];
    hud.activityIndicatorColor = [UIColor blackColor];
    
    [cell.photoImageView sd_setImageWithURL:currentPhotoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideAllHUDsForView:cell animated:YES];
    }];
    
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
