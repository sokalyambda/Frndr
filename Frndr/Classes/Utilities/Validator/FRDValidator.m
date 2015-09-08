//
//  Validator.m
//  CarusselSalesTool
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDValidator.h"

NSString *const kValidationErrorTitle = @"validationErrorTitle";
NSString *const kValidationErrorMessage = @"validationErrorMessage";

@implementation FRDValidator

static NSMutableDictionary *_errorDict;

#pragma mark - Accessors

+ (NSMutableDictionary *)validationErrorDict
{
    @synchronized(self) {
        if (!_errorDict) {
            _errorDict = [NSMutableDictionary dictionary];
        }
        return _errorDict;
    }
}

+ (void)setValidationErrorDict:(NSMutableDictionary *)validationErrorDict
{
    @synchronized(self) {
        _errorDict = validationErrorDict;
    }
}

#pragma mark - Other actions

/**
 *  Clean the validation error string
 */
+ (void)cleanValidationErrorDict
{
    [self setValidationErrorDict:[@{} mutableCopy]];
}

+ (void)setErrorTitle:(NSString *)errorTitle andMessage:(NSString *)message
{
    [[self validationErrorDict] setObject:errorTitle forKey:kValidationErrorTitle];
    [[self validationErrorDict] setObject:message forKey:kValidationErrorMessage];
}

@end
