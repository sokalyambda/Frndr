//
//  FRDGetChatHistoryRequest.h
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDGetChatHistoryRequest : FRDNetworkRequest

@property (strong, nonatomic) NSArray *chatHistory;

- (instancetype)initWithFriendId:(NSString *)friendId andPage:(NSInteger)page;

@end
