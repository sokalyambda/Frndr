//
//  FRDClearMessageRequest.h
//  Frndr
//
//  Created by Pavlo on 10/14/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDClearMessageRequest : FRDNetworkRequest

- (void)initWithMessageId:(NSString *)messageId;

@end
