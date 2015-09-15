//
//  FRDRelationshipItem.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRelationshipItem.h"

@interface FRDRelationshipItem ()

@end

@implementation FRDRelationshipItem

#pragma mark - Lifecycle

- (instancetype)initWithTitle:(NSString *)title andActiveImage:(UIImage *)image andNotActiveImage:(UIImage *)notActiveImage
{
    self = [super init];
    if (self) {
        _relationshipTitle = title;
        _relationshipImage = image;
        _relationshipNotActiveImage = notActiveImage;
    }
    return self;
}

+ (instancetype)relationshipItemWithTitle:(NSString *)title andActiveImage:(UIImage *)activeImage andNotActiveImage:(UIImage *)notActiveImage
{
    return [[self alloc] initWithTitle:title andActiveImage:activeImage andNotActiveImage:notActiveImage];
}

@end
