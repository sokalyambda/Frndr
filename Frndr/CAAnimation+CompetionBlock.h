//
//  Competion.h
//  DivePlanit
//
//  Created by Mykhailo Glagola on 18.11.14.
//  Copyright (c) 2014 Kirill Gorbushko. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (CompetionBlock)

/// Block called when animation strart
@property (copy) void (^begin)(void);

/// Block called when animation stop
@property (copy) void (^end)(BOOL end);

@end
