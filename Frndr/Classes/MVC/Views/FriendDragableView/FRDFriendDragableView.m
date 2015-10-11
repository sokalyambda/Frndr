//
//  FRDFriendDragableView.m
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendDragableView.h"

#import "FRDNearestUser.h"
#import "FRDSexualOrientation.h"

#import "UIView+MakeFromXib.h"

@interface FRDFriendDragableView ()

@property (weak, nonatomic) IBOutlet UIImageView *friendProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendSmokerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualOrientationLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;

@end

@implementation FRDFriendDragableView

#pragma mark - Accessors

- (void)setOverlayImageName:(NSString *)overlayImageName
{
    _overlayImageName = overlayImageName;
    self.overlayImageView.image = [UIImage imageNamed:overlayImageName];
}

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

- (void)configureWithNearestUser:(FRDNearestUser *)nearestUser
{
    self.friendNameLabel.text = nearestUser.fullName;
    self.friendAgeLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)nearestUser.age];
    self.friendDistanceLabel.text = [NSString stringWithFormat:@"%f", nearestUser.distanceFromMe];
    self.friendSmokerLabel.text = [NSString stringWithFormat:@"%@", nearestUser.isSmoker ? LOCALIZED(@"Smoker") : LOCALIZED(@"Non-Smoker")];
    self.sexualOrientationLabel.text = nearestUser.sexualOrientation.orientationString;
    self.jobTitleLabel.text = nearestUser.jobTitle;
    
    [self.friendProfileImageView sd_setImageWithURL:nearestUser.avatarURL];
}

- (void)commonInit
{
    self.layer.cornerRadius = 10.f;
}

@end
