//
//  FRDBasicChatCell.h
//  Frndr
//
//  Created by Pavlo on 10/2/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRDChatCellType)
{
    FRDChatCellTypeUser,
    FRDChatCellTypeFriend,
    FRDChatCellTypeSystem
};

typedef NS_ENUM(NSInteger, FRDChatCellPositionInSet)
{
    FRDChatCellPositionInSetFirst,
    FRDChatCellPositionInSetIntermediary,
    FRDChatCellPositionInSetLast
};

@interface FRDBaseChatCell : UITableViewCell

@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *timeStamp;
@property (assign, nonatomic) FRDChatCellPositionInSet positionInSet;

+ (instancetype)chatCellWithType:(FRDChatCellType)cellType;

@end
