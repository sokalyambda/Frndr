//
//  FRDRelationshipItem.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRelationshipItem.h"

@interface FRDRelationshipItem ()

@property (nonatomic) NSString *relationshipActiveImageName;
@property (nonatomic) NSString *relationshipNotActiveImageName;

@end

@implementation FRDRelationshipItem

#pragma mark - Accessors

- (void)setRelationshipActiveImageName:(NSString *)relationshipActiveImageName
{
    _relationshipActiveImageName = relationshipActiveImageName;
    _relationshipActiveImage = [UIImage imageNamed:_relationshipActiveImageName];
}

- (void)setRelationshipNotActiveImageName:(NSString *)relationshipNotActiveImageName
{
    _relationshipNotActiveImageName = relationshipNotActiveImageName;
    _relationshipNotActiveImage = [UIImage imageNamed:_relationshipNotActiveImageName];
}

#pragma mark - Lifecycle

- (instancetype)initWithTitle:(NSString *)title andActiveImageName:(NSString *)activeImageName andNotActiveImage:(NSString *)notActiveImageName
{
    self = [super init];
    if (self) {
        _relationshipTitle = title;
        
        self.relationshipActiveImageName = activeImageName;
        self.relationshipNotActiveImageName = notActiveImageName;
    }
    return self;
}

+ (instancetype)relationshipItemWithTitle:(NSString *)title andActiveImage:(NSString *)activeImageName andNotActiveImage:(NSString *)notActiveImageName
{
    return [[self alloc] initWithTitle:title andActiveImageName:activeImageName andNotActiveImage:notActiveImageName];
}

@end
