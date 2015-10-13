//
//  FRDClearMessagesWithFriendRequest.h
//  Frndr
//
//  Created by Eugenity on 13.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDClearMessagesWithFriendRequest : FRDNetworkRequest

- (instancetype)initWithFriendId:(NSString *)friendId;

@end
