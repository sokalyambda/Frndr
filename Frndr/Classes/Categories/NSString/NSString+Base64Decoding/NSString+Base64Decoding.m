//
//  NSString+Base64Decoding.m
//  BizrateRewards
//
//  Created by Eugenity on 30.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "NSString+Base64Decoding.h"

@implementation NSString (Base64Decoding)

- (UIImage *)decodeBase64ToImage
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
