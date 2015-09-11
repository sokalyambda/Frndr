//
//  BZRSerialViewConstructor.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDSerialViewConstructor.h"

static NSString *const kDoneButtonImageName = @"topRightIcon";
static NSString *const kBackArrowImageName = @"backArrow";

static CGFloat const kDoneFontSize = 14.f;

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
//    UIImage *faceImage = [UIImage imageNamed:kBackArrowImageName];
//    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
//    face.bounds = CGRectMake( 0, 0, faceImage.size.width, faceImage.size.height );
//    [face setImage:faceImage forState:UIControlStateNormal];
//    UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
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
    UIImage *backgroundImage = [[UIImage imageNamed:kDoneButtonImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *topRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topRightButton setFrame:CGRectMake(0.0f, 0.0f, backgroundImage.size.width, backgroundImage.size.height)];
    
    [topRightButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [topRightButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:topRightButton];
    
    return doneBarButton;
}

@end
