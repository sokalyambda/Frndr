//
//  UIResponder+FirstResponder.m
//  GovMap
//
//  Created by Pavlo on 9/1/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
