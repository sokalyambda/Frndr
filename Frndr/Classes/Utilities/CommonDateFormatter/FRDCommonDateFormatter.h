//
//  BZRCommonDateFormatter.h
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class ISO8601DateFormatter;

@interface FRDCommonDateFormatter : NSObject

+ (NSDateFormatter *)commonDateFormatter;

+ (ISO8601DateFormatter *)commonISO8601DateFormatter;

@end
