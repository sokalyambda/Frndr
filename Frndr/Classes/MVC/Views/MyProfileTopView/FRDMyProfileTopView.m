//
//  FRDMyProfileTopView.m
//  Frndr
//
//  Created by Pavlo on 9/21/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDMyProfileTopView.h"

@interface FRDMyProfileTopView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@end

@implementation FRDMyProfileTopView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

#pragma mark - Actions

- (void)commonInit
{
    FRDFacebookProfile *currentFacebookProfile = [FRDStorageManager sharedStorage].currentFacebookProfile;
    self.nameLabel.text = currentFacebookProfile.fullName;
    self.ageLabel.text = [NSString localizedStringWithFormat:@"%d %@", currentFacebookProfile.age, LOCALIZED(@"years")];
    self.genderLabel.text = currentFacebookProfile.genderString;
    
    [self.avatarImageView sd_setImageWithURL:currentFacebookProfile.avararURL];
}

@end
