//
//  FRDMyProfileTopView.m
//  Frndr
//
//  Created by Pavlo on 9/21/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMyProfileTopView.h"

#import "FRDAvatar.h"
#import "FRDFriend.h"

@interface FRDMyProfileTopView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@end

@implementation FRDMyProfileTopView

#pragma mark - Actions

- (void)updateProfileTopViewForFriend:(FRDFriend *)currentFriend
{
    FRDCurrentUserProfile *currentUserProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    
    FRDBaseUserModel *profileForUpdating = currentFriend ?: currentUserProfile;

    self.nameLabel.text = profileForUpdating.fullName;
    self.ageLabel.text = [NSString localizedStringWithFormat:@"%d %@", profileForUpdating.age, LOCALIZED(@"years")];
    self.genderLabel.text = profileForUpdating.genderString;
    
    if (profileForUpdating.currentAvatar.photoURL) {
        [self.avatarImageView sd_setImageWithURL:profileForUpdating.currentAvatar.photoURL]; //avatar from server
    } else {
        [self.avatarImageView sd_setImageWithURL:profileForUpdating.avatarURL]; //avatar from facebook
    }
}

@end
