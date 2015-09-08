//
//  NSDictionary+JSONRepresentation.m
//  vdiabete
//
//  Created by EugeneS on 28.04.15.
//  Copyright (c) 2015 kttsoft. All rights reserved.
//

#import "NSDictionary+JSONRepresentation.h"

@implementation NSDictionary (JSONRepresentation)

- (NSString *)jsonStringFromDictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    NSString *jsonString;
    
    if (! jsonData) {
        NSLog(@"Error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
