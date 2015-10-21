//
//  FRDPhotoGalleryController.m
//  Frndr
//
//  Created by Pavlo on 9/23/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef void(^PhotoSelectionCompletion)(UIImage *chosenImage);

#import "FRDPhotoGalleryController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDPhotoGalleryCollectionViewCell.h"

#import "FRDProjectFacade.h"

#import "FRDAvatar.h"
#import "FRDFriend.h"

#import "UIImage+Base64Encoding.h"
#import "UIImage+Scale.h"

@interface FRDPhotoGalleryController () <UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FRDGalleryCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *photosGallery;
@property (strong, nonatomic) FRDAvatar *currentAvatar;

@property (copy, nonatomic) PhotoSelectionCompletion photoCompletion;

@end

@implementation FRDPhotoGalleryController

#pragma mark - Accessors

- (FRDAvatar *)currentAvatar
{
    if (!self.currentFriend) {
        _currentAvatar = [FRDStorageManager sharedStorage].currentUserProfile.currentAvatar;
    }
    return _currentAvatar;
}

- (void)setPhotosGallery:(NSArray *)photosGallery
{
    _photosGallery = photosGallery;
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - View's Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //for user
    [self updateForCurrentUserProfile];
    //for friend
    [self updateForFriendProfile];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (FRDGallegyType)currentGalleryType
{
    return self.currentFriend ? FRDGallegyTypeFriend : FRDGallegyTypeUser;
}

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
    return self.currentFriend ? self.photosGallery.count + 1 : self.photosGallery.count + 2; //first image is avatar and last image is 'plus' (if friend exists - add only avatar)
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDPhotoGalleryCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FRDPhotoGalleryCollectionViewCell class]) forIndexPath:indexPath];

    cell.delegate = self;
    
    if (indexPath.row < self.photosGallery.count + 1) {
        
        if (indexPath.row == 0) {
            [cell configureWithGalleryPhoto:self.currentAvatar andGalleryType:[self currentGalleryType]];
        } else {
            FRDGalleryPhoto *galleryPhoto = self.photosGallery[indexPath.row - 1];
            [cell configureWithGalleryPhoto:galleryPhoto andGalleryType:[self currentGalleryType]];
        }
        
    } else {
        [cell configureWithGalleryPhoto:nil andGalleryType:[self currentGalleryType]];
    }
    
    return cell;
}

#pragma mark - Change photo actions

/**
 *  Manage photos for current user profile
 */
- (void)updateForCurrentUserProfile
{
    if (self.currentFriend) {
        return;
    }
    
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

/**
 *  Show photos for current friend
 */
- (void)updateForFriendProfile
{
    if (!self.currentFriend) {
        return;
    }
    self.photosGallery = self.currentFriend.galleryPhotos;
    self.currentAvatar = self.currentFriend.currentAvatar;
}

/**
 *  Show remove photo action sheet
 */
- (void)showRemovePhotoActionSheetWithPhoto:(FRDGalleryPhoto *)photo
{
    UIAlertController *removePhotoController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Do you want to remove this photo?") preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Remove") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [weakSelf removePhoto:photo];
        
    }];
    
    [removePhotoController addAction:cancelAction];
    [removePhotoController addAction:confirmAction];
    
    [self presentViewController:removePhotoController animated:YES completion:nil];
}

/**
 *  Show remove avatar action sheet
 */
- (void)showRemoveAvatarActionSheet
{
    UIAlertController *removeAvatarController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Do you want to remove your avatar?") preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Remove") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf removeAvatar];
        
    }];
    
    [removeAvatarController addAction:cancelAction];
    [removeAvatarController addAction:confirmAction];
    
    [self presentViewController:removeAvatarController animated:YES completion:nil];
}

/**
 *  Choose new photo and set it as user avatar image. (To make it work we have to change parent class of BZRRoundedImageView from FBSDKProfilePictureView to UIImageView).
 */
- (void)setupChangePhotoActionSheetWithCompletion:(PhotoSelectionCompletion)completion
{
    self.photoCompletion = completion;
    
    WEAK_SELF;
    UIAlertController *changePhotoActionSheet = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Select photo") preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Take photo") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf takeNewPhotoFromCamera];
    }];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Select from gallery") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf choosePhotoFromExistingImages];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [changePhotoActionSheet addAction:cameraAction];
    [changePhotoActionSheet addAction:galleryAction];
    [changePhotoActionSheet addAction:cancelAction];
    
    [self presentViewController:changePhotoActionSheet animated:YES completion:nil];
}

/**
 *  Show exchange avatar with gallery photo action sheet
 */
- (void)showExchangeAvatarWithGalleryPhotoActionSheetWithGalleryPhoto:(FRDGalleryPhoto *)galleryPhoto
{
    UIAlertController *exchangeAvatarAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *setAsProfilePictureAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Set as Profile Picture") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //set as profile picture
        [weakSelf exchangeCurrentAvatarWithGalleryPhoto:galleryPhoto];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [exchangeAvatarAlertController addAction:setAsProfilePictureAction];
    [exchangeAvatarAlertController addAction:cancelAction];
    
    [self presentViewController:exchangeAvatarAlertController animated:YES completion:nil];
}

/**
 *  Exchange avatar with gallery photo
 *
 *  @param galleryPhoto Photo for new avatar
 */
- (void)exchangeCurrentAvatarWithGalleryPhoto:(FRDGalleryPhoto *)galleryPhoto
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade exchangeCurrentAvatarWithGalleryPhoto:galleryPhoto onSuccess:^(FRDAvatar *updatedAvatar) {
        
        [FRDProjectFacade getGalleryOnSuccess:^(NSArray *gallery) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            weakSelf.photosGallery = gallery;
            [weakSelf updateCurrentAvatarWithAvatar:updatedAvatar];
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Remove current photo
 *
 *  @param photo Photo for removing
 */
- (void)removePhoto:(FRDGalleryPhoto *)photo
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade removePhotoFromGallery:photo onSuccess:^(BOOL isSuccess) {
        
        [FRDProjectFacade getGalleryOnSuccess:^(NSArray *gallery) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            weakSelf.photosGallery = gallery;
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Remove current avatar
 */
- (void)removeAvatar
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade removeAvatarOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        //avatar has been removed
        [FRDStorageManager sharedStorage].currentUserProfile.currentAvatar = nil;
        
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Upload photo to gallery
 */
- (void)uploadPhotoToGallery:(UIImage *)chosenImage
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [FRDProjectFacade uploadPhotoToGallery:chosenImage onSuccess:^(BOOL isSuccess) {
        
        [FRDProjectFacade getGalleryOnSuccess:^(NSArray *gallery) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            weakSelf.photosGallery = gallery;
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Upload avatar
 */
- (void)uploadAvatar:(UIImage *)newAvatar
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade uploadUserAvatar:newAvatar onSuccess:^(BOOL isSuccess) {
        
        [FRDProjectFacade getAvatarWithSmallValue:NO onSuccess:^(FRDAvatar *avatar) {
            
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            [weakSelf updateCurrentAvatarWithAvatar:avatar];
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  If camera source type is available - show camera.
 */
- (void)takeNewPhotoFromCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [FRDAlertFacade showAlertWithMessage:LOCALIZED(@"Camera is not available") forController:self withCompletion:nil];
        return;
    } else {
        [self showImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
    }
}

/**
 *  Choose photo from photo library
 */
- (void)choosePhotoFromExistingImages
{
    [self showImagePickerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

/**
 *  Setup UIImagePickerController
 *
 *  @param type Chosen type
 */
- (void)showImagePickerWithType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.sourceType = type;
    picker.mediaTypes = @[(NSString*)kUTTypeImage];
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 *  Update current user avatar
 *
 *  @param avatar New Avatar
 */
- (void)updateCurrentAvatarWithAvatar:(FRDAvatar *)avatar
{
    [FRDStorageManager sharedStorage].currentUserProfile.currentAvatar = avatar;
    
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (image) {

        UIImage *resizedImage = [image imageByScalingAndCroppingForSize:CGSizeMake(600.f, 600.f)];
        
        if (self.photoCompletion) {
            [picker dismissViewControllerAnimated:YES completion:nil];
            self.photoCompletion(resizedImage);
            self.photoCompletion = nil;
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FRDGalleryCellDelegate

- (void)galleryCell:(FRDPhotoGalleryCollectionViewCell *)cell didTapPlusImageView:(UIImageView *)plusImageView
{
    if (self.currentFriend) {
        return;
    }
    
    BOOL isAvatar = [self.collectionView indexPathForCell:cell].row == 0 ? YES : NO;
    WEAK_SELF;
    [self setupChangePhotoActionSheetWithCompletion:^(UIImage *chosenImage) {
        
        if (isAvatar) {
            [weakSelf uploadAvatar:chosenImage];
        } else {
            [weakSelf uploadPhotoToGallery:chosenImage];
        }
    }];
}

- (void)galleryCell:(FRDPhotoGalleryCollectionViewCell *)cell didTapCrossImageView:(UIImageView *)crossImageView
{
    if (self.currentFriend) {
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    if (indexPath.row == 0) {
        [self showRemoveAvatarActionSheet];
    } else {
        FRDGalleryPhoto *currentPhoto = self.photosGallery[indexPath.row - 1];
        [self showRemovePhotoActionSheetWithPhoto:currentPhoto];
    }
}

- (void)galleryCell:(FRDPhotoGalleryCollectionViewCell *)cell didTapGalleryPhotoImageView:(UIImageView *)galleryPhotoView
{
    if (self.currentFriend) {
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    if (indexPath.row == 0) {
        return;
    } else {
        FRDGalleryPhoto *currentPhoto = self.photosGallery[indexPath.row - 1];
        [self showExchangeAvatarWithGalleryPhotoActionSheetWithGalleryPhoto:currentPhoto];
    }
}

@end
