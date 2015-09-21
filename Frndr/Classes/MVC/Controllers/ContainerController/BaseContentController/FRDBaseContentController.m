//
//  FRDBaseContentController.m
//  Frndr
//
//  Created by Eugenity on 21.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseContentController.h"

#import "FRDTopContentView.h"

#import "UIView+MakeFromXib.h"

@interface FRDBaseContentController ()

@property (nonatomic) NSString *titleString;
@property (nonatomic) NSString *leftImageName;
@property (nonatomic) NSString *rightImageName;

@end

@implementation FRDBaseContentController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (void)customizeTopView:(FRDTopContentView *)topContentView
{
    if (self.titleString.length) {
        topContentView.topTitleText = self.titleString;
    }
    topContentView.leftIconName = self.leftImageName;
    topContentView.rightIconName = self.rightImageName;
}

@end
