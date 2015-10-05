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
    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:0];
}

@end
