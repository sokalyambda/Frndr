//
//  FRDChatOption.m
//  Frndr
//
//  Created by Pavlo on 10/7/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatOption.h"

@implementation FRDChatOption

#pragma mark - Lifecycle

- (instancetype)initWithOptionType:(FRDChatOptionsType)type
{
    self = [super init];
    if (self) {
        
        switch (type) {
            case FRDChatOptionsTypeBlockUser: {
                _optionString = LOCALIZED(@"Block User");
                break;
            }
            case FRDChatOptionsTypeClearChat: {
                _optionString = LOCALIZED(@"Clear Chat");
                break;
            }
            case FRDChatOptionsTypeViewProfile: {
                _optionString = LOCALIZED(@"View Profile");
                break;
            }
            case FRDChatOptionsTypeCancel: {
                _optionString = LOCALIZED(@"Cancel");
                break;
            }
    
            default:
                break;
        }
    }
    return self;
}

+ (instancetype)chatOptionWithOptionType:(FRDChatOptionsType)type
{
    return [[self alloc] initWithOptionType:type];
}

@end
