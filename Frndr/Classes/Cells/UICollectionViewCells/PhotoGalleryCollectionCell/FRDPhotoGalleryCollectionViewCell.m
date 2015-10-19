//
//  FRDPhotoGalleryCollectionViewCell.m
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryCollectionViewCell.h"

#import "FRDAvatar.h"

#import "UIView+Pulsing.h"

@interface FRDPhotoGalleryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *crossImageView;
@property (weak, nonatomic) IBOutlet UIImageView *plusImageView;
@property (weak, nonatomic) IBOutlet UIView *transparencyView;
@property (weak, nonatomic) IBOutlet UILabel *profilePictureLabel;

@property (strong, nonatomic) UITapGestureRecognizer *crossTap;
@property (strong, nonatomic) UITapGestureRecognizer *plusTap;

@end

@implementation FRDPhotoGalleryCollectionViewCell

#pragma mark - Accessors

- (UITapGestureRecognizer *)crossTap
{
    if (!_crossTap) {
        _crossTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCrossClick:)];
    }
    return _crossTap;
}

- (UITapGestureRecognizer *)plusTap
{
    if (!_plusTap) {
        _plusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlusClick:)];
    }
    return _plusTap;
}

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
    if (![self.gestureRecognizers containsObject:self.crossTap]) {
        [self.crossImageView addGestureRecognizer:self.crossTap];
    }
    if (![self.gestureRecognizers containsObject:self.plusTap]) {
        [self.plusImageView addGestureRecognizer:self.plusTap];
    }
}

/**
 *  Confidure cell with photo
 *
 *  @param photo current gallery photo
 */
- (void)configureWithGalleryPhoto:(FRDGalleryPhoto *)photo
                   andGalleryType:(FRDGallegyType)galleryType
{
    self.transparencyView.hidden = self.profilePictureLabel.hidden = ![photo isKindOfClass:[FRDAvatar class]];//+
    self.plusImageView.hidden = (!!photo.photoURL || galleryType == FRDGallegyTypeFriend);
    self.crossImageView.hidden = (!photo.photoURL || galleryType == FRDGallegyTypeFriend);
    self.imageView.hidden = !photo.photoURL;
    
    if (photo.photoURL) {
        [self configureHud];
        WEAK_SELF;
        [self.imageView sd_setImageWithURL:photo.photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        }];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self addTapGestures];
    });
}

- (void)handlePlusClick:(UITapGestureRecognizer *)tap
{
    [self.plusImageView highlightWithScaling];
    
    if ([self.delegate respondsToSelector:@selector(galleryCell:didTapPlusImageView:)]) {
        [self.delegate galleryCell:self didTapPlusImageView:self.plusImageView];
    }
}

- (void)handleCrossClick:(UITapGestureRecognizer *)tap
{
    [self.crossImageView highlightWithScaling];
    
    if ([self.delegate respondsToSelector:@selector(galleryCell:didTapCrossImageView:)]) {
        [self.delegate galleryCell:self didTapCrossImageView:self.crossImageView];
    }
}

- (void)configureHud
{
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.color = [[UIColor clearColor] copy];
    hud.activityIndicatorColor = [UIColor blackColor];
    hud.alpha = .5f;
}

@end
