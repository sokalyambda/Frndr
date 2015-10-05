//
//  FRDPhotoGalleryCollectionViewCell.m
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryCollectionViewCell.h"

#import "FRDGalleryPhoto.h"

@interface FRDPhotoGalleryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FRDPhotoGalleryCollectionViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}

#pragma mark - Actions

- (void)configureWithGalleryPhoto:(FRDGalleryPhoto *)photo
{
    if (!photo) {
        [self.imageView setImage:[UIImage imageNamed:@"plusSymbol"]];
    } else {
        [self.imageView sd_setImageWithURL:photo.photoURL];
    }
}

@end
