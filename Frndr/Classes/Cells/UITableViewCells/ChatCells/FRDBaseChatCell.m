//
//  FRDBasicChatCell.m
//  Frndr
//
//  Created by Pavlo on 10/2/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseChatCell.h"
#import "FRDUserChatCell.h"
#import "FRDFriendChatCell.h"
#import "FRDSystemChatCell.h"

#import "FRDRoundedImageView.h"

#import "FRDBaseUserModel.h"

@interface FRDBaseChatCell ()

@property (weak, nonatomic) IBOutlet FRDRoundedImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;

@end

@implementation FRDBaseChatCell

#pragma mark - Lifecycle

- (instancetype)initWithChatCellType:(FRDChatCellType)cellType
{
    id currentChatCell = nil;
    
    switch (cellType) {
        case FRDChatCellTypeUser: {
            currentChatCell = [[FRDUserChatCell alloc] init];
            break;
        }
        case FRDChatCellTypeFriend: {
            currentChatCell = [[FRDFriendChatCell alloc] init];
            break;
        }
            
        case FRDChatCellTypeSystem: {
            currentChatCell = [[FRDSystemChatCell alloc] init];
            break;
        }
    }
    
    return currentChatCell;
}

+ (instancetype)chatCellWithType:(FRDChatCellType)cellType
{
    return [[self alloc] initWithChatCellType:cellType];
}

@end
