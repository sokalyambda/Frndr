//
//  UIImage+Base64Encoding.m
//  BizrateRewards
//
//  Created by Eugenity on 30.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "UIImage+Base64Encoding.h"

@implementation UIImage (Base64Encoding)

- (NSString *)encodeToBase64String
{
    NSLog(@"length %u KB", [UIImageJPEGRepresentation(self, 0.6f) length] * 1024);
    return [UIImageJPEGRepresentation(self, 0.6f) base64EncodedStringWithOptions:kNilOptions];
}

@end
