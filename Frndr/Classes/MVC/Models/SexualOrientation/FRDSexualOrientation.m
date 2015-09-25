//
//  FRDSexualOrientatiom.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSexualOrientation.h"

@implementation FRDSexualOrientation

#pragma mark - Lifecycle

- (instancetype)initWithOrientationString:(NSString *)string
{
    self = [super init];
    if (self) {
        _orientationString = string;
    }
    return self;
}

@end
