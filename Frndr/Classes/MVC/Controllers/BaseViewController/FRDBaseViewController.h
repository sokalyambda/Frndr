//
//  FDRBaseViewController.h
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSUInteger, FRDSourceType) {
    FRDSourceTypeSearchSettings,
    FRDSourceTypeMyProfile
};

#import "FRDNavigationTitleView.h"

@interface FRDBaseViewController : UIViewController

@property (strong, nonatomic) FRDNavigationTitleView *navigationTitleView;

@property (assign, nonatomic) FRDSourceType currentSourceType;

- (void)customizeNavigationItem;

@end
