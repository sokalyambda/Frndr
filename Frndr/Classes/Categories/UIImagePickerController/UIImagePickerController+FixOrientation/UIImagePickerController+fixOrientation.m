//
//  UIImagePickerController+fixOrientation.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 09.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "UIImagePickerController+fixOrientation.h"

@implementation UIImagePickerController (fixOrientation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
