//
//  BZRSerialViewConstructor.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDSerialViewConstructor.h"

static NSString *const kDoneButtonImageName = @"done_btn";
static NSString *const kBackArrowImageName = @"back_arrow";

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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kBackArrowImageName] style:UIBarButtonItemStylePlain target:controller action:action];
    return backButton;
}

/**
 *  Create custom 'Done' button with specific background image
 *
 *  @param controller Receiver of custom 'Done' button
 *  @param action     Selector that will be passed to 'Done' button
 *
 *  @return Custom Done Button
 */
+ (UIBarButtonItem *)customButtonWithTitle:(NSString *)title forController:(UIViewController *)controller withAction:(SEL)action
{
    UIImage *backgroundImage = [UIImage imageNamed:kDoneButtonImageName];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0.0f, 0.0f, backgroundImage.size.width, backgroundImage.size.height)];
    
    [doneButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [doneButton setTitle:LOCALIZED(title) forState:UIControlStateNormal];
    
    doneButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:kDoneFontSize];
    
    [doneButton setTitleColor:UIColorFromRGB(0x091e40) forState:UIControlStateNormal];
    
    [doneButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    return doneBarButton;
}

@end
