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
    FRDChatCellPositionInSetLast
};

@class FRDChatMessage, FRDFriend;

@interface FRDBaseChatCell : UITableViewCell

@property (assign, nonatomic) FRDChatCellPositionInSet positionInSet;

+ (instancetype)chatCellWithMessage:(FRDChatMessage *)message;

- (void)configureForFriend:(FRDFriend *)currentFriend withMessage:(FRDChatMessage *)message;

@end
