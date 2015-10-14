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

@class FRDFriend;

@interface FRDChatMessagesService : NSObject

+ (void)getChatHistoryWithFriend:(NSString *)friendId
                         andPage:(NSInteger)page
                       onSuccess:(ChatHistorySuccess)success
                       onFailure:(ChatHistoryFailure)failure;

+ (void)sendMessage:(NSString *)messageBody
     toFriendWithId:(NSString *)friendId
          onSuccess:(SuccessBlock)success
          onFailure:(FailureBlock)failure;

+ (void)clearMessagesHistoryWithFriendWithId:(NSString *)friendId
                                   onSuccess:(SuccessBlock)success
                                   onFailure:(FailureBlock)failure;

+ (void)clearMessageWithId:(NSString *)messageId
                 onSuccess:(SuccessBlock)success
                 onFailure:(FailureBlock)failure;

+ (FRDChatCellPositionInSet)positionOfCellInSetByIndexPath:(NSIndexPath *)indexPath
                                         inMessagesHistory:(NSArray *)messagesHistory;

+ (FRDMessageOwnerType)ownerTypeForMessage:(FRDChatMessage *)message;

+ (FRDFriend *)findFriendWithId:(NSString *)friendId
                        inArray:(NSArray *)friends;

@end
