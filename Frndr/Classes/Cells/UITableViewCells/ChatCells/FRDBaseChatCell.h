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

@property (nonatomic) NSString *message;
@property (nonatomic) NSDate *timeStamp;

+ (instancetype)chatCellWithType:(FRDChatCellType)cellType;

@end
