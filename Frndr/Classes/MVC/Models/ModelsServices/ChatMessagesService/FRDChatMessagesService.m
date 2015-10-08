//
//  FRDChatMessagesService.m
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatMessagesService.h"

@implementation FRDChatMessagesService

#pragma mark - Actions

+ (FRDMessageOwnerType)ownerTypeForMessage:(FRDChatMessage *)message
{
    FRDMessageOwnerType currentType;
    
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    if ([message.ownerId isEqualToString:currentProfile.userId]) {
        currentType = FRDMessageOwnerTypeUser;
    } else {
        currentType = FRDMessageOwnerTypeFriend;
    }
    return currentType;
}

+ (void)getChatHistoryWithFriend:(NSString *)friendId
                         andPage:(NSInteger)page
                       onSuccess:(ChatHistorySuccess)success
                       onFailure:(ChatHistoryFailure)failure
{
    [FRDProjectFacade getChatHistoryWithFriendId:friendId andPage:page onSuccess:^(NSArray *chatHistory) {
        
        if (success) {
            success(chatHistory);
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (void)sendMessage:(NSString *)messageBody
     toFriendWithId:(NSString *)friendId
          onSuccess:(SuccessBlock)success
          onFailure:(FailureBlock)failure
{
    [FRDProjectFacade sendMessage:messageBody toFriendWithId:friendId onSuccess:^(BOOL isSuccess) {
        
        if (success) {
            success(isSuccess);
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error, isCanceled);
        }
        
    }];
}

+ (FRDChatCellPositionInSet)positionOfCellInSetByIndexPath:(NSIndexPath *)indexPath
                                            inMessagesHistory:(NSArray *)messagesHistory
{
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    
    FRDChatMessage *previousMessage;
    FRDChatMessage *nextMessage;
    FRDChatMessage *currentMessage = messagesHistory[indexPath.row];
    
    if (nextIndexPath.row < messagesHistory.count) {
        nextMessage = messagesHistory[nextIndexPath.row];
    }
    if (previousIndexPath.row >= 0) {
        previousMessage = messagesHistory[previousIndexPath.row];
    }
    
    if (!previousMessage && !nextMessage) { //it is the first cell at all
        
        return FRDChatCellPositionInSetOnly;
        
    } else if (!previousMessage && nextMessage) {
        
        if (nextMessage.ownerType == currentMessage.ownerType) {
            return FRDChatCellPositionInSetFirst;
        } else {
            return FRDChatCellPositionInSetOnly;
        }
        
    } else if (previousMessage && !nextMessage) {
        
        if (previousMessage.ownerType == currentMessage.ownerType) {
            return FRDChatCellPositionInSetLast;
        } else {
            return FRDChatCellPositionInSetOnly;
        }
        
    } else {

        if (previousMessage.ownerType == currentMessage.ownerType && nextMessage.ownerType == currentMessage.ownerType) {
            
            return FRDChatCellPositionInSetIntermediary;
            
        } else if (previousMessage.ownerType == currentMessage.ownerType) {
            
            return FRDChatCellPositionInSetLast;
            
        } else if (nextMessage.ownerType == currentMessage.ownerType) {
            
            return FRDChatCellPositionInSetFirst;
            
        } else {
            return FRDChatCellPositionInSetOnly;
        }
    }
}

@end
