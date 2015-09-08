//
//  Validator.h
//  CarusselSalesTool
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^ValidationSuccessBlock)(void);
typedef void(^ValidationFailureBlock)(NSMutableDictionary *errorDict);

extern NSString *const kValidationErrorTitle;
extern NSString *const kValidationErrorMessage;

@interface FRDValidator : NSObject

+ (NSMutableDictionary *)validationErrorDict;
+ (void)setValidationErrorDict:(NSMutableDictionary *)validationErrorDict;

+ (void)cleanValidationErrorDict;

@end
