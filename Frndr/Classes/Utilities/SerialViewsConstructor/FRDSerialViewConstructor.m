//
//  BZRSerialViewConstructor.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDSerialViewConstructor.h"

static NSString *const kTopIconImageName = @"topRightIcon";
static NSString *const kBackArrowImageName = @"backArrow";

@implementation FRDSerialViewConstructor

/**
 *  Create custom back button for controller
 *
 *  @param controller Receiver of custom back button
 *
 *  @return Custom Back Button
 */
+ (UIBarButtonItem *)backButtonForController:(UIViewController *)controller withAction:(SEL)action
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:kBackArrowImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:controller action:action];
    return backButton;
}

/**
 *  Create custom right icon button with specific background image
 *
 *  @param controller Receiver of custom right icon button
 *  @param action     Selector that will be passed to right icon button
 *
 *  @return Custom Right Icon
 */
+ (UIBarButtonItem *)customRightBarButtonForController:(UIViewController *)controller withAction:(SEL)action
{
    return [self customRightBarButtonForController:controller withAction:action andImageName:kTopIconImageName];
}

/**
 *  Create custom right icon button with custom background image
 *
 *  @param controller    Receiver of custom right icon button
 *  @param action        Selector that will be passed to right icon button
 *  @param imageName     Name of the image that will be assigned to item
 *
 *  @return Custom Right Icon
 */
+ (UIBarButtonItem *)customRightBarButtonForController:(UIViewController *)controller withAction:(SEL)action andImageName:(NSString *)imageName
{
    UIImage *backgroundImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *topRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topRightButton setFrame:CGRectMake(0.0f, 0.0f, backgroundImage.size.width, backgroundImage.size.height)];
    
    [topRightButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [topRightButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:topRightButton];
    
    return doneBarButton;
}

/**
 *  Create custom bar button item
 *
 *  @param image      Image for bar button
 *  @param controller Controller
 *  @param action     Selector
 *
 *  @return Custom bar button
 */
+ (UIBarButtonItem *)customBarButtonWithImage:(UIImage *)image forController:(UIViewController *)controller withAction:(SEL)action
{
    UIBarButtonItem *customBarButton = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:controller action:action];
    return customBarButton;
}

@end
