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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions

- (void)configureWithFriend:(FRDFriend *)friend_
{
    // ...
    
    // Remove text padding from text view
    self.messageTextView.textContainer.lineFragmentPadding = 0;
    self.messageTextView.textContainerInset = UIEdgeInsetsZero;
}

@end
