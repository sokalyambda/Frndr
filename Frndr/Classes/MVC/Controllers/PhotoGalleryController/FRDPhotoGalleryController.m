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

@interface FRDPhotoGalleryController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FRDPhotoGalleryController

#pragma mark - View's Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRDPhotoGalleryCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FRDPhotoGalleryCollectionViewCell class]) forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"Tutorial01"];
    return cell;
}

@end
