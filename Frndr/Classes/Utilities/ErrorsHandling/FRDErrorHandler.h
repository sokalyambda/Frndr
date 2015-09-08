//
//  BZRErrorHandler.h
//  BizrateRewards
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^ErrorParsingCompletion)(NSString *alertTitle, NSString *alertMessage);

@interface FRDErrorHandler : NSObject

+ (BOOL)errorIsNetworkError:(NSError *)error;

+ (void)parseError:(NSError *)error withCompletion:(ErrorParsingCompletion)completion;

@end
