//
//  BZRSerialViewConstructor.h
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface FRDSerialViewConstructor : NSObject

+ (UIBarButtonItem *)backButtonForController:(UIViewController *)controller withAction:(SEL)action;

+ (UIBarButtonItem *)customButtonWithTitle:(NSString *)title forController:(UIViewController *)controller withAction:(SEL)action;

@end
