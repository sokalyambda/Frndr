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
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@end

@implementation FRDMyProfileTopView

#pragma mark - Actions

- (void)updateProfileTopView
{
    FRDCurrentUserProfile *currentUserProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    
    self.nameLabel.text = currentUserProfile.fullName;
    self.ageLabel.text = [NSString localizedStringWithFormat:@"%d %@", currentUserProfile.age, LOCALIZED(@"years")];
    self.genderLabel.text = currentUserProfile.genderString;
    
    if (currentUserProfile.currentAvatar.photoURL) {
        [self.avatarImageView sd_setImageWithURL:currentUserProfile.currentAvatar.photoURL]; //avatar from server
    } else {
        [self.avatarImageView sd_setImageWithURL:currentUserProfile.avatarURL]; //avatar from facebook
    }
}

@end
