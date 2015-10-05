//
//  FRDPhotoGalleryCollectionViewCell.m
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryCollectionViewCell.h"

#import "FRDAvatar.h"

@interface FRDPhotoGalleryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *crossImageView;
@property (weak, nonatomic) IBOutlet UIImageView *plusImageView;
@property (weak, nonatomic) IBOutlet UIView *transparencyView;
@property (weak, nonatomic) IBOutlet UILabel *profilePictureLabel;

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
    self.transparencyView.hidden = self.profilePictureLabel.hidden = ![photo isKindOfClass:[FRDAvatar class]];
    self.plusImageView.hidden = !!photo;
    self.crossImageView.hidden = !photo;
    
    if (photo) {
        [self.imageView sd_setImageWithURL:photo.photoURL];
    }
}

@end
