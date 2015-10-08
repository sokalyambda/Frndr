//
//  FRDBasicChatCell.h
//  Frndr
//
//  Created by Pavlo on 10/2/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRDChatCellPositionInSet)
{
    FRDChatCellPositionInSetFirst,
    FRDChatCellPositionInSetIntermediary,
    FRDChatCellPositionInSetLast,
    FRDChatCellPositionInSetOnly
};

#import "FRDChatMessage.h"

@class FRDFriend, FRDRoundedImageView;

@interface FRDBaseChatCell : UITableViewCell {
    @protected
    __weak IBOutlet FRDRoundedImageView *avatarImageView;
    __weak IBOutlet UITextView *messageTextView;
    __weak IBOutlet UILabel *dateAndTimeLabel;
}

@property (assign, nonatomic) FRDChatCellPositionInSet positionInSet;

+ (instancetype)chatCellWithOwnerType:(FRDMessageOwnerType)ownerType
                         forTableView:(UITableView *)tableView
                          atIndexPath:(NSIndexPath *)indexPath;

- (void)configureForFriend:(FRDFriend *)currentFriend withMessage:(FRDChatMessage *)message;

@end
