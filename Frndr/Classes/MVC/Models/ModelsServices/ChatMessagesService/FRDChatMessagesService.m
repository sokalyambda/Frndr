//
//  FRDChatMessagesService.m
//  Frndr
//
//  Created by Eugenity on 07.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatMessagesService.h"

#import "FRDFriend.h"

@implementation FRDChatMessagesService

#pragma mark - Actions

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

+ (void)clearMessagesHistoryWithFriendWithId:(NSString *)friendId
                                   onSuccess:(SuccessBlock)success
                                   onFailure:(FailureBlock)failure
{
    [FRDProjectFacade clearMessagesWithFriendWithId:friendId onSuccess:^(BOOL isSuccess) {
        
        if (success) {
            success(YES);
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error, isCanceled);
        }
        
    }];
}

+ (void)clearMessageWithId:(NSString *)messageId
                 onSuccess:(SuccessBlock)success
                 onFailure:(FailureBlock)failure
{
    [FRDProjectFacade clearMessageWithId:messageId onSuccess:^(BOOL isSuccess) {
        
        if (success) {
            success(YES);
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

+ (FRDFriend *)findFriendWithId:(NSString *)friendId
                        inArray:(NSArray *)friends
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", friendId];
    FRDFriend *messageOwner = [[friends filteredArrayUsingPredicate:predicate] firstObject];
    return messageOwner;
}

+ (void)updateCurrentFriendsLastMessages:(NSArray *)friendsArray withNewFriendsArray:(NSArray *)newFriends
{
    @autoreleasepool {
        for (FRDFriend *currentFriend in friendsArray) {
            for (FRDFriend *newFriend in newFriends) {
                if ([currentFriend.userId isEqualToString:newFriend.userId]) {
                    currentFriend.lastMessage = newFriend.lastMessage;
                    currentFriend.lastMessagePostedDate = newFriend.lastMessagePostedDate;
                    currentFriend.hasNewMessages = newFriend.hasNewMessages;
                    break;
                }
            }
        }
    }
    
}

@end
