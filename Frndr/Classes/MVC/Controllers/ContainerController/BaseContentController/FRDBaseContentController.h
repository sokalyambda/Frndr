//
//  FRDBaseContentController.h
//  Frndr
//
//  Created by Eugenity on 21.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseViewController.h"

@class FRDTopContentView;

@interface FRDBaseContentController : FRDBaseViewController

- (void)customizeTopView:(FRDTopContentView *)topContentView;

@property (assign, nonatomic) BOOL transitionWithDamping;

@end
