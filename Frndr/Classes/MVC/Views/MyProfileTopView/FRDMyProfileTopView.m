//
//  FRDMyProfileTopView.m
//  Frndr
//
//  Created by Pavlo on 9/21/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMyProfileTopView.h"

#import "FRDAvatar.h"

@interface FRDMyProfileTopView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@end

@implementation FRDMyProfileTopView

#pragma mark - Actions

- (void)updateProfileTopViewForFriend:(FRDBaseUserModel *)currentProfile
{
    self.nameLabel.text = currentProfile.fullName;
    self.genderLabel.text = currentProfile.genderString;
    
    if (currentProfile.currentAvatar.photoURL) {
        [self.avatarImageView sd_setImageWithURL:currentProfile.currentAvatar.photoURL]; //avatar from server
    } else {
        [self.avatarImageView sd_setImageWithURL:currentProfile.avatarURL]; //avatar from facebook
    }
}

@end
