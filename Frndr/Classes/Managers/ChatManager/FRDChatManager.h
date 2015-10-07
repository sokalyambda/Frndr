//
//  FRDChatManager.h
//  Frndr
//
//  Created by Eugenity on 06.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@interface FRDChatManager : NSObject

+ (FRDChatManager *)sharedChatManager;

- (void)closeChannel;

@end
