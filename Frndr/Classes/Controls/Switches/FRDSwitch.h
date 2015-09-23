//
//  FRDSwitch.h
//  CustomSwitch
//
//  Created by Pavlo on 9/20/15.
//  Copyright © 2015 Pavlo. All rights reserved.
//

@interface FRDSwitch : UIControl

@property (readonly, nonatomic, getter=isOn) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

- (void)setSwitchImage:(UIImage *)image;
- (void)setOnImage:(UIImage *)image;
- (void)setOffImage:(UIImage *)image;
- (void)setOnText:(NSString *)text withFont:(UIFont *)font andColor:(UIColor *)color;
- (void)setOffText:(NSString *)text withFont:(UIFont *)font andColor:(UIColor *)color;

@end
