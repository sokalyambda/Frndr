//
//  FRDSwitch.h
//  CustomSwitch
//
//  Created by Pavlo on 9/20/15.
//  Copyright © 2015 Pavlo. All rights reserved.
//

@interface FRDSwitch : UIControl

@property (readonly, getter=isOn, nonatomic) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

- (void)setSwitchImage:(UIImage *)image;
- (void)setOnImage:(UIImage *)image;
- (void)setOffImage:(UIImage *)image;
- (void)setOnText:(NSString *)text withFontDescriptor:(UIFontDescriptor *)descriptor andColor:(UIColor *)color;
- (void)setOffText:(NSString *)text withFontDescriptor:(UIFontDescriptor *)descriptor andColor:(UIColor *)color;

@end
