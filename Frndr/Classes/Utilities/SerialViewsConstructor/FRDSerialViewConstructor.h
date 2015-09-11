//
//  BZRSerialViewConstructor.h
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface FRDSerialViewConstructor : NSObject

+ (UIBarButtonItem *)backButtonForController:(UIViewController *)controller withAction:(SEL)action;

+ (UIBarButtonItem *)customRightBarButtonForController:(UIViewController *)controller withAction:(SEL)action;

@end
