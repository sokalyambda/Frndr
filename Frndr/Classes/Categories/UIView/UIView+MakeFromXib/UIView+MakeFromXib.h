//
//  UIView+MakeFromXib.h
//
//  Created by Konstantin on 29/08/2014.
//  Copyright (c) 2014 kttsoft. All rights reserved.
//

@interface UIView (MakeFromXib)

+ (instancetype)makeFromXibWithFileOwner:(id)owner;
+ (instancetype)makeFromXib;

@end
