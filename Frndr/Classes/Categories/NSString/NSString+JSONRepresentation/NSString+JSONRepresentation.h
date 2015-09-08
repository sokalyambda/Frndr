//
//  NSString+JSONRepresentation.h
//  BizrateRewards
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSONRepresentation)

- (NSDictionary *)dictionaryFromJSONString;

@end
