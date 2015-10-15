//
//  FRDDropDownHolderController.h
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseViewController.h"

@class FRDSexualOrientation, FRDFriend;

@interface FRDDropDownHolderController : FRDBaseViewController

@property (nonatomic) UIView *viewForDisplaying;

@property (nonatomic) BOOL smoker;
@property (nonatomic) FRDSexualOrientation *chosenOrientation;

- (void)updateWithSourceType:(FRDSourceType)sourceType;

- (void)updateWithFriend:(FRDFriend *)currentFriend;

@end
