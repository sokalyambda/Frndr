//
//  FRDChatOption.m
//  Frndr
//
//  Created by Pavlo on 10/7/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatOption.h"

@implementation FRDChatOption

#pragma mark - Lifecycle

- (instancetype)initWithOptionString:(NSString *)string
{
    self = [super init];
    if (self) {
        _optionString = string;
        
        NSMutableArray *selectorStringComponents = [[string componentsSeparatedByString:@" "] mutableCopy];
        NSString *firstWord = selectorStringComponents.firstObject;
        firstWord = [firstWord lowercaseString];
        selectorStringComponents[0] = firstWord;
        
        NSString *finalSelectorString = [[selectorStringComponents componentsJoinedByString:@""] stringByAppendingString:@"OptionClick"];
        
        _optionSelector = NSSelectorFromString(finalSelectorString);
    }
    return self;
}

+ (instancetype)optionWithOptionString:(NSString *)string
{
    return [[self alloc] initWithOptionString:string];
}

@end
