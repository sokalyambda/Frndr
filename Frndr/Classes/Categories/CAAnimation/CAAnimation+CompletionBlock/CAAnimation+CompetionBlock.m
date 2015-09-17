//
//  Competion.m
//  DivePlanit
//
//  Created by Mykhailo Glagola on 18.11.14.
//  Copyright (c) 2014 Kirill Gorbushko. All rights reserved.
//

#import "CAAnimation+CompetionBlock.h"

@implementation CAAnimation (CompetionBlock)
@dynamic begin;
@dynamic end;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (self.begin) {
        self.begin();
        self.begin = nil;
    }
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.end) {
        self.end(flag);
        self.end = nil;
    }
}

@end
