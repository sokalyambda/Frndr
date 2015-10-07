//
//  FRDBasicChatCell.m
//  Frndr
//
//  Created by Pavlo on 10/2/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseChatCell.h"
#import "FRDBaseChatCell_Private.h"

#import "FRDUserChatCell.h"
#import "FRDFriendChatCell.h"
#import "FRDSystemChatCell.h"

#import "FRDChatMessage.h"
#import "FRDFriend.h"

#import "UIView+MakeFromXib.h"
#import "NSDate+TimeAgo.h"

static CGFloat const kTimeStampLabelPreferredHeight = 20.f;

@interface FRDBaseChatCell ()

@property (nonatomic) IBOutlet NSLayoutConstraint *timeStampLabelHeight;

@end

@implementation FRDBaseChatCell

#pragma mark - Accessors

- (void)setPositionInSet:(FRDChatCellPositionInSet)positionInSet
{
    _positionInSet = positionInSet;
    
    switch (positionInSet) {
        case FRDChatCellPositionInSetFirst: {
            self.timeStampLabelHeight.constant = 0;
            self.avatarImageView.hidden = NO;
            break;
        }
            
        case FRDChatCellPositionInSetIntermediary: {
            self.timeStampLabelHeight.constant = 0;
            self.avatarImageView.hidden = YES;
            break;
        }
            
        case FRDChatCellPositionInSetLast: {
            self.timeStampLabelHeight.constant = kTimeStampLabelPreferredHeight;
            self.avatarImageView.hidden = YES;
            break;
        }
    }
}

#pragma mark - Lifecycle

- (instancetype)initWithMessage:(FRDChatMessage *)message
{
    FRDBaseChatCell *currentChatCell = nil;
    
    switch (message.ownerType) {
        case FRDMessageOwnerTypeUser: {
            currentChatCell = [FRDUserChatCell makeFromXib];
            break;
        }
            
        case FRDMessageOwnerTypeFriend: {
            currentChatCell = [FRDFriendChatCell makeFromXib];
            break;
        }
            
        case FRDMessageOwnerTypeSystem: {
            currentChatCell = [FRDSystemChatCell makeFromXib];
            break;
        }
    }
    
    return currentChatCell;
}

+ (instancetype)chatCellWithMessage:(FRDChatMessage *)message
{
    return [[self alloc] initWithMessage:message];
}

#pragma mark - Actions

- (void)configureForFriend:(FRDFriend *)currentFriend withMessage:(FRDChatMessage *)message
{
    if (!currentFriend) {
        [self.avatarImageView sd_setImageWithURL:[FRDStorageManager sharedStorage].currentUserProfile.avatarURL];
    } else {
        [self.avatarImageView sd_setImageWithURL:currentFriend.avatarURL];
    }
    
    self.messageTextView.text = message.messageBody;
    self.dateAndTimeLabel.text = [message.creationDate dateTimeAgo];
}

@end
