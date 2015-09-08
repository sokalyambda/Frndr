//
//  FRDTutorialContentController.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDTutorialContentController.h"

@interface FRDTutorialContentController ()

@end

@implementation FRDTutorialContentController

#pragma mark - Accessors

- (void)setImageName:(NSString *)name
{
    _imageName = name;
    self.contentImageView.image = [UIImage imageNamed:_imageName];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentImageView.image = [UIImage imageNamed:self.imageName];
}

@end
