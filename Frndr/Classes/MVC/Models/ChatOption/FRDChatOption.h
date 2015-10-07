//
//  FRDChatOption.h
//  Frndr
//
//  Created by Pavlo on 10/7/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRDChatOption : NSObject

@property (nonatomic) NSString *optionString;
@property (nonatomic) SEL optionSelector;

+ (instancetype)optionWithOptionString:(NSString *)string;

@end
