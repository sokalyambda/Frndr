//
//  FRDFriendCellTableViewCell.m
//  Frndr
//
//  Created by Pavlo on 9/17/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendCell.h"

#import "FRDFriend.h"

#import "NSDate+TimeAgo.h"

@interface FRDFriendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *incomingMessageIcon;

@end

@implementation FRDFriendCell

#pragma mark - Actions

- (void)configureWithFriend:(FRDFriend *)currentFriend
{
    self.messageLabel.text = currentFriend.lastMessage;
    [self.avatarImageView sd_setImageWithURL:currentFriend.avatarURL];
    self.nameLabel.text = currentFriend.fullName;
    self.timeAndDateLabel.text = [currentFriend.lastMessagePostedDate dateTimeAgo];
    
    self.messageLabel.textColor = currentFriend.isNewFriend ? UIColorFromRGB(0x35B8B4) : UIColorFromRGB(0x58406B);
    
    self.incomingMessageIcon.alpha = currentFriend.hasNewMessages ? 1.f : 0.f;
}

@end
