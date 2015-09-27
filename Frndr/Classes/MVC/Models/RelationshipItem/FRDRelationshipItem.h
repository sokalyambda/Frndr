//
//  FRDRelationshipItem.h
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@interface FRDRelationshipItem : NSObject

@property (nonatomic, readonly) NSString *relationshipTitle;

@property (nonatomic, readonly) UIImage *relationshipActiveImage;
@property (nonatomic, readonly) UIImage *relationshipNotActiveImage;

@property (nonatomic) BOOL isSelected;

+ (instancetype)relationshipItemWithTitle:(NSString *)title andActiveImage:(NSString *)activeImageName andNotActiveImage:(NSString *)notActiveImageName;

@end
