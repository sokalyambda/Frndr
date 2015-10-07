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

@end
