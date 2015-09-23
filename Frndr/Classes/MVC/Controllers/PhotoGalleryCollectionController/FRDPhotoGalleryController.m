//
//  FRDPhotoGalleryController.m
//  Frndr
//
//  Created by Pavlo on 9/23/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryController.h"

#import "FRDSerialViewConstructor.h"

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

@end
