//
//  FRDFriendCellTableViewCell.m
//  Frndr
//
//  Created by Pavlo on 9/17/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendCell.h"

@implementation FRDFriendCell

- (void)awakeFromNib {
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame) / 3.0;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions

- (void)configureWithFriend:(FRDFriend *)friend_
{
    self.messageLabel.text = @"This text is hardcoded This text is hardcoded This text is hardcoded This text is hardcoded v This text is hardcoded This text is hardcoded This text is hardcoded This text is hardcoded";
    
    self.avatarImageView.image = [UIImage imageNamed:@"CoupleActiveIcon"];
}

@end
