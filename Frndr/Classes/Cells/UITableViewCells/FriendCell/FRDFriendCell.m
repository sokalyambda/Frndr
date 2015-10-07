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

@end

@implementation FRDFriendCell

#pragma mark - Actions

- (void)configureWithFriend:(FRDFriend *)currentFriend
{
    self.messageLabel.text = currentFriend.lastMessage;
    [self.avatarImageView sd_setImageWithURL:currentFriend.avatarURL];
    self.nameLabel.text = currentFriend.fullName;
    self.timeAndDateLabel.text = [currentFriend.lastMessagePostedDate dateTimeAgo];
    
    if (currentFriend.isNewFriend) {
        self.messageLabel.textColor = UIColorFromRGB(0x35B8B4);
    }
}

@end
