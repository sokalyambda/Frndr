//
//  FRDPhotoGalleryController.m
//  Frndr
//
//  Created by Pavlo on 9/23/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDPhotoGalleryCollectionViewCell.h"

#import "FRDProjectFacade.h"

#import "FRDAvatar.h"

@interface FRDPhotoGalleryController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *photosGallery;
@property (strong, nonatomic) FRDAvatar *currentAvatar;

@end

@implementation FRDPhotoGalleryController

#pragma mark - Accessors

- (FRDAvatar *)currentAvatar
{
    if (!_currentAvatar) {
        _currentAvatar = [FRDStorageManager sharedStorage].currentUserProfile.currentAvatar;
    }
    return _currentAvatar;
}

- (void)setPhotosGallery:(NSArray *)photosGallery
{
    _photosGallery = photosGallery;
    [self.collectionView reloadData];
}

#pragma mark - View's Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getAvatarAndGalleryOnSuccess:^(FRDAvatar *avatar, NSArray *gallery) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        weakSelf.photosGallery = gallery;
        if (!weakSelf.currentAvatar) {
            weakSelf.currentAvatar = avatar;
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationTitleView.titleText = LOCALIZED(@"Photos");
    
    UIBarButtonItem *rightIcon = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:nil];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = rightIcon;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosGallery.count + 2; //first image is avatar and last image is 'plus'
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDPhotoGalleryCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FRDPhotoGalleryCollectionViewCell class]) forIndexPath:indexPath];

    if (indexPath.row != self.photosGallery.count + 1) {
        
        if (indexPath.row == 0) {
            [cell configureWithGalleryPhoto:self.currentAvatar];
        } else {
            FRDGalleryPhoto *galleryPhoto = self.photosGallery[indexPath.row];
            [cell configureWithGalleryPhoto:galleryPhoto];
        }
        
    } else {
        [cell configureWithGalleryPhoto:nil];
    }
    
    return cell;
}

@end
