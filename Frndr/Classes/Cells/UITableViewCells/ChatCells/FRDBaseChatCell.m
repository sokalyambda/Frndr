//
//  FRDBasicChatCell.m
//  Frndr
//
//  Created by Pavlo on 10/2/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseChatCell.h"

#import "FRDFriend.h"

#import "UIView+MakeFromXib.h"
#import "NSDate+TimeAgo.h"

#import "FRDUserChatCell.h"
#import "FRDFriendChatCell.h"
#import "FRDSystemChatCell.h"

#import "FRDRoundedImageView.h"

static CGFloat const kTimeStampLabelPreferredHeight = 20.f;
static CGFloat const kAvatarPreferredHeight = 70.f;

@interface FRDBaseChatCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeStampLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightConstraint;

@end

@implementation FRDBaseChatCell

#pragma mark - Accessors

- (void)setPositionInSet:(FRDChatCellPositionInSet)positionInSet
{
    _positionInSet = positionInSet;
    
    switch (positionInSet) {
        case FRDChatCellPositionInSetFirst: {
            self.timeStampLabelHeight.constant = 0;
            self.avatarHeightConstraint.constant = kAvatarPreferredHeight;
            break;
        }
            
        case FRDChatCellPositionInSetIntermediary: {
            self.timeStampLabelHeight.constant = 0;
            self.avatarHeightConstraint.constant = 0;
            break;
        }
            
        case FRDChatCellPositionInSetLast: {
            self.timeStampLabelHeight.constant = kTimeStampLabelPreferredHeight;
            self.avatarHeightConstraint.constant = 0;
            break;
        }
            
        case FRDChatCellPositionInSetOnly: {
            self.timeStampLabelHeight.constant = kTimeStampLabelPreferredHeight;
            self.avatarHeightConstraint.constant = kAvatarPreferredHeight;
            break;
        }
    }
}

#pragma mark - Lifecycle

- (instancetype)initWithOwnerType:(FRDMessageOwnerType)ownerType
                   forTableView:(UITableView *)tableView
                    atIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    
    switch (ownerType) {
        case FRDMessageOwnerTypeUser: {
            cellIdentifier = NSStringFromClass([FRDUserChatCell class]);
            break;
        }
            
        case FRDMessageOwnerTypeFriend: {
            cellIdentifier = NSStringFromClass([FRDFriendChatCell class]);
            break;
        }
            
        case FRDMessageOwnerTypeSystem: {
            cellIdentifier = NSStringFromClass([FRDSystemChatCell class]);
            break;
        }
    }
    
    FRDBaseChatCell *currentChatCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!currentChatCell) {
        currentChatCell = [NSClassFromString(cellIdentifier) makeFromXib];
    }
    
    return currentChatCell;
}

+ (instancetype)chatCellWithOwnerType:(FRDMessageOwnerType)ownerType
                       forTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
{
    return [[self alloc] initWithOwnerType:ownerType forTableView:tableView atIndexPath:indexPath];
}

#pragma mark - Actions

- (void)configureForFriend:(FRDFriend *)currentFriend
               withMessage:(FRDChatMessage *)message
{
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;

    switch (message.ownerType) {
        case FRDMessageOwnerTypeFriend: {
            [self->avatarImageView sd_setImageWithURL:currentFriend.avatarURL];
            break;
        }
        case FRDMessageOwnerTypeUser: {
            [self->avatarImageView sd_setImageWithURL:currentProfile.avatarURL];
            break;
        }
        case FRDMessageOwnerTypeSystem: {
            break;
        }
            
        default:
            break;
    }
    self->messageTextView.text = message.messageBody;
    self->dateAndTimeLabel.text = [message.creationDate dateTimeAgo];
}

@end
