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

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
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

- (void)addTapGestures
{
    UITapGestureRecognizer *crossTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCrossClick:)];
    [self.crossImageView addGestureRecognizer:crossTap];
    
    UITapGestureRecognizer *plusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlusClick:)];
    [self.plusImageView addGestureRecognizer:plusTap];
}

- (void)configureWithGalleryPhoto:(FRDGalleryPhoto *)photo
{
    self.transparencyView.hidden = self.profilePictureLabel.hidden = ![photo isKindOfClass:[FRDAvatar class]];
    self.plusImageView.hidden = !!photo;
    self.crossImageView.hidden = self.imageView.hidden = !photo;
    
    if (photo) {
        WEAK_SELF;
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:[MBProgressHUD class]]) {
                [subview removeFromSuperview];
            }
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.color = [[UIColor clearColor] copy];
        hud.activityIndicatorColor = [UIColor blackColor];
        
        [self.imageView sd_setImageWithURL:photo.photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        }];
    }
    
    [self addTapGestures];
}

- (void)handlePlusClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(galleryCell:didTapPlusImageView:)]) {
        [self.delegate galleryCell:self didTapPlusImageView:self.plusImageView];
    }
}

- (void)handleCrossClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(galleryCell:didTapCrossImageView:)]) {
        [self.delegate galleryCell:self didTapCrossImageView:self.crossImageView];
    }
}

@end
