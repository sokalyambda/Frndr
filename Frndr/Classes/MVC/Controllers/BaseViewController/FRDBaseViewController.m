//
//  FDRBaseViewController.m
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseViewController.h"
#import "FRDBaseNavigationController.h"

@interface FRDBaseViewController ()

@property (weak, nonatomic) FRDBaseNavigationController *baseNavigationController;

@end

@implementation FRDBaseViewController

#pragma mark - Accessors

- (FRDBaseNavigationController *)baseNavigationController
{
    if (!_baseNavigationController && [self.navigationController isKindOfClass:[FRDBaseNavigationController class]]) {
        _baseNavigationController = (FRDBaseNavigationController *)self.navigationController;
    }
    return _baseNavigationController;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationItem];
}

- (void)customizeNavigationItem
{
    self.navigationItem.leftBarButtonItem = self.baseNavigationController.customBackButton;
}

@end
