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

static CGFloat const kTimeStampLabelPreferredHeight = 20.f;

@interface FRDBaseChatCell ()

@property (nonatomic) IBOutlet NSLayoutConstraint *timeStampLabelHeight;

@end

@implementation FRDBaseChatCell

#pragma mark - Accessors

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.messageTextView.text = message;
}

- (void)setTimeStamp:(NSDate *)timeStamp
{
    _timeStamp = timeStamp;
    
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
    
    formatter.dateFormat = @"hh:mm a";
    dateAndTime = [dateAndTime stringByAppendingString:[formatter stringFromDate:timeStamp]];
    
    self.dateAndTimeLabel.text = dateAndTime;
}

- (void)setPositionInSet:(FRDChatCellPositionInSet)positionInSet
{
    _positionInSet = positionInSet;
    
    switch (positionInSet) {
        case FRDChatCellPositionInSetFirst: {
            self.timeStampLabelHeight.constant = 0;
            self.avatarImageView.hidden = NO;
            break;
        }
            
        case FRDChatCellPositionInSetIntermediary: {
            self.timeStampLabelHeight.constant = 0;
            self.avatarImageView.hidden = YES;
            break;
        }
            
        case FRDChatCellPositionInSetLast: {
            self.timeStampLabelHeight.constant = kTimeStampLabelPreferredHeight;
            self.avatarImageView.hidden = YES;
            break;
        }
    }
}

#pragma mark - Lifecycle

- (instancetype)initWithChatCellType:(FRDChatCellType)cellType
{
    FRDBaseChatCell *currentChatCell = nil;
    
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

- (void)configureTextView
{
    
}

@end
