//
//  FRDUserChatCell.m
//  Frndr
//
//  Created by Pavlo on 10/2/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDUserChatCell.h"

#import "FRDRoundedImageView.h"

@interface FRDUserChatCell ()

@end

@implementation FRDUserChatCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    FRDCurrentUserProfile *profile = [FRDStorageManager sharedStorage].currentUserProfile;
    [self->avatarImageView sd_setImageWithURL:profile.avatarURL];
}

@end
