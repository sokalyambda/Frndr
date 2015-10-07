//
//  FRDSendMessageRequest.h
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDSendMessageRequest : FRDNetworkRequest

- (instancetype)initWithFriendId:(NSString *)friendId andMessageBody:(NSString *)messageBody;

@end
