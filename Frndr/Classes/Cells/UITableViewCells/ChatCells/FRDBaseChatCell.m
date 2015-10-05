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

#import "FRDBaseUserModel.h"

#import "UIView+MakeFromXib.h"

@interface FRDBaseChatCell ()

@end

@implementation FRDBaseChatCell

#pragma mark - Lifecycle

- (instancetype)initWithChatCellType:(FRDChatCellType)cellType
{
    id currentChatCell = nil;
    
    switch (cellType) {
        case FRDChatCellTypeUser: {
            currentChatCell = [FRDUserChatCell makeFromXib];
            break;
        }
        case FRDChatCellTypeFriend: {
            currentChatCell = [FRDFriendChatCell makeFromXib];
            break;
        }
            
        case FRDChatCellTypeSystem: {
            currentChatCell = [FRDSystemChatCell makeFromXib];
            break;
        }
    }
    
    return currentChatCell;
}

+ (instancetype)chatCellWithType:(FRDChatCellType)cellType
{
    return [[self alloc] initWithChatCellType:cellType];
}

#pragma mark - Actions

- (void)configureWithMessage:(NSString *)message
                   timeStamp:(NSDate *)timeStamp
               positionInSet:(FRDChatCellPositionInSet)positionInSet
{
    self.messageTextView.text = message;
    
    switch (positionInSet) {
        case FRDChatCellPositionInSetFirst: {
            self.dateAndTimeLabel.text = @"";
            self.avatarImageView.hidden = NO;
            break;
        }
            
        case FRDChatCellPositionInSetIntermediary: {
            self.dateAndTimeLabel.text = @"";
            self.avatarImageView.hidden = YES;
            break;
        }
            
        case FRDChatCellPositionInSetLast: {
            self.avatarImageView.hidden = YES;
            
            NSString *dateAndTime = @"";
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            if ([[NSCalendar currentCalendar] isDateInToday:timeStamp]) {
                dateAndTime = [dateAndTime stringByAppendingString:@"Today "];
            } else if ([[NSCalendar currentCalendar] isDateInYesterday:timeStamp]) {
                dateAndTime = [dateAndTime stringByAppendingString:@"Yesterday "];
            } else {
                formatter.dateFormat = @"dd";
                dateAndTime = [dateAndTime stringByAppendingString:[formatter stringFromDate:timeStamp]];
            }
            
            formatter.dateFormat = @"HH:mm";
            dateAndTime = [dateAndTime stringByAppendingString:[formatter stringFromDate:timeStamp]];
            
            self.dateAndTimeLabel.text = dateAndTime;
            
            break;
        }
    }
}

@end
