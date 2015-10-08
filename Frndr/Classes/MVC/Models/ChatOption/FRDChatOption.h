//
//  FRDChatOption.h
//  Frndr
//
//  Created by Pavlo on 10/7/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRDChatOptionType)
{
    FRDChatOptionTypeViewProfile,
    FRDChatOptionTypeClearChat,
    FRDChatOptionTypeBlockUser,
    FRDChatOptionTypeCancel
};

@interface FRDChatOption : NSObject

@property (readonly, nonatomic) FRDChatOptionType type;
@property (readonly, nonatomic) NSString *titleString;

+ (instancetype)optionWithOptionType:(FRDChatOptionType)type;

@end
