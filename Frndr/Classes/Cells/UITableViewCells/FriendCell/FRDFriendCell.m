//
//  FRDFriendCellTableViewCell.m
//  Frndr
//
//  Created by Pavlo on 9/17/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendCell.h"

@interface FRDFriendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;

@end

@implementation FRDFriendCell

#pragma mark - Actions

- (void)configureWithFriend:(FRDFriend *)currentFriend
{
    self.messageLabel.text = @"This text is hardcoded This text is hardcoded This text is hardcoded This text is hardcoded v This text is hardcoded This text is hardcoded This text is hardcoded This text is hardcodedThis text is hardcoded This text is hardcoded This text is hardcoded This text is hardcoded v This text is hardcoded This text is hardcoded This text is hardcoded This text is hardcodedThis text is hardcoded This text is hardcoded This text is hardcoded This text is hardcoded v This text is hardcoded This text is hardcoded This text is hardcoded This text is hardcoded";
    
    self.avatarImageView.image = [UIImage imageNamed:@"CoupleActiveIcon"];
}

@end
