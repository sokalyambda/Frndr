//
//  FRDChatMessagesService.h
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef void(^ChatHistorySuccess)(NSArray *chatHistory);
typedef void(^ChatHistoryFailure)(NSError *error);

#import "FRDChatMessage.h"

#import "FRDBaseChatCell.h"

#import "FRDProjectFacade.h"

@interface FRDChatMessagesService : NSObject

+ (FRDMessageOwnerType)ownerTypeForMessage:(FRDChatMessage *)message;

+ (void)getChatHistoryWithFriend:(NSString *)friendId
                         andPage:(NSInteger)page
                       onSuccess:(ChatHistorySuccess)success
                       onFailure:(ChatHistoryFailure)failure;

+ (void)sendMessage:(NSString *)messageBody
     toFriendWithId:(NSString *)friendId
          onSuccess:(SuccessBlock)success
          onFailure:(FailureBlock)failure;

+ (FRDChatCellPositionInSet)positionOfCellInSetByIndexPath:(NSIndexPath *)indexPath
                                            inMessagesHistory:(NSArray *)messagesHistory;

@end
