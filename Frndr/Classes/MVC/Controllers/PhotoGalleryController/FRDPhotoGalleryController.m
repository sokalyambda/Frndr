//
//  FRDPhotoGalleryController.m
//  Frndr
//
//  Created by Pavlo on 9/23/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef void(^PhotoSelectionCompletion)(NSString *base64ImageString, UIImage *chosenImage);

#import "FRDPhotoGalleryController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDPhotoGalleryCollectionViewCell.h"

#import "FRDProjectFacade.h"

#import "FRDAvatar.h"

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
    if (!_currentAvatar) {
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

    cell.delegate = self;
    
    if (indexPath.row != self.photosGallery.count + 1) {
        
        if (indexPath.row == 0) {
            [cell configureWithGalleryPhoto:self.currentAvatar];
        } else {
            FRDGalleryPhoto *galleryPhoto = self.photosGallery[indexPath.row - 1];
            [cell configureWithGalleryPhoto:galleryPhoto];
        }
        
    } else {
        [cell configureWithGalleryPhoto:nil];
    }
    
    return cell;
}

#pragma mark - Change photo actions

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
    [FRDProjectFacade removeAvatarOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDStorageManager sharedStorage].currentUserProfile.currentAvatar = nil;
        [weakSelf.collectionView reloadData];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
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

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (image) {

        UIImage *resizedImage = [image imageByScalingAndCroppingForSize:CGSizeMake(600.f, 600.f)];
        
        NSString *base64String = @"";//[image encodeToBase64String];
        if (self.photoCompletion) {
            [picker dismissViewControllerAnimated:YES completion:nil];
            self.photoCompletion(base64String, resizedImage);
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
    WEAK_SELF;
    [self setupChangePhotoActionSheetWithCompletion:^(NSString *base64ImageString, UIImage *chosenImage) {
        
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
        
    }];
}

- (void)galleryCell:(FRDPhotoGalleryCollectionViewCell *)cell didTapCrossImageView:(UIImageView *)crossImageView
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    if (indexPath.row == 0) {
        [self showRemoveAvatarActionSheet];
    } else {
        FRDGalleryPhoto *currentPhoto = self.photosGallery[indexPath.row - 1];
        [self showRemovePhotoActionSheetWithPhoto:currentPhoto];
    }
    
}

@end
