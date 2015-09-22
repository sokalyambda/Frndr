//
//  UIImage+ColoredImage.m
//  Frndr
//
//  Created by Pavlo on 9/22/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "UIImage+ColoredImage.h"

@implementation UIImage (ColoredImage)

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
