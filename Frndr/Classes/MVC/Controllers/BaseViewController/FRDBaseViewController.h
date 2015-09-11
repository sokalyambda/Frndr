//
//  FDRBaseViewController.h
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNavigationTitleView.h"

@interface FRDBaseViewController : UIViewController

@property (strong, nonatomic) FRDNavigationTitleView *navigationTitleView;

- (void)customizeNavigationItem;

@end
