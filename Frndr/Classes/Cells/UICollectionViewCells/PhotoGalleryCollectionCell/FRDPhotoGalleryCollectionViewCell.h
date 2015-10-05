//
//  FRDPhotoGalleryCollectionViewCell.h
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class FRDGalleryPhoto;
@protocol FRDGalleryCellDelegate;

@interface FRDPhotoGalleryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) id<FRDGalleryCellDelegate> delegate;

- (void)configureWithGalleryPhoto:(FRDGalleryPhoto *)photo;

@end

@protocol FRDGalleryCellDelegate <NSObject>

@optional
- (void)galleryCell:(FRDPhotoGalleryCollectionViewCell *)cell didTapCrossImageView:(UIImageView *)crossImageView;
- (void)galleryCell:(FRDPhotoGalleryCollectionViewCell *)cell didTapPlusImageView:(UIImageView *)plusImageView;

@end