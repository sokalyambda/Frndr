//
//  FRDChatOption.h
//  Frndr
//
//  Created by Pavlo on 10/7/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSUInteger, FRDChatOptionsType) {
    FRDChatOptionsTypeViewProfile,
    FRDChatOptionsTypeClearChat,
    FRDChatOptionsTypeBlockUser,
    FRDChatOptionsTypeCancel
};

@interface FRDChatOption : NSObject

@property (nonatomic, readonly) NSString *optionString;
@property (nonatomic, readonly) FRDChatOptionsType currentType;

+ (instancetype)chatOptionWithOptionType:(FRDChatOptionsType)type;

@end
