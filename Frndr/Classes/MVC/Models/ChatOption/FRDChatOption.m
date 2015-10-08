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

- (instancetype)initWithOptionType:(FRDChatOptionType)type
{
    self = [super init];
    if (self) {
        _type = type;
        
        switch (type) {
            case FRDChatOptionTypeViewProfile: {
                _titleString = @"View Profile";
                break;
            }
                
            case FRDChatOptionTypeClearChat: {
                _titleString = @"Clear Chat";
                break;
            }
                
            case FRDChatOptionTypeBlockUser: {
                _titleString = @"Block User";
                break;
            }
                
            case FRDChatOptionTypeCancel: {
                _titleString = @"Cancel";
                break;
            }
        }
    }
    return self;
}

+ (instancetype)optionWithOptionType:(FRDChatOptionType)type
{
    return [[self alloc] initWithOptionType:type];
}

@end
