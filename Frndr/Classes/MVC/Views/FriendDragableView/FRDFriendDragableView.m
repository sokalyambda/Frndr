//
//  FRDFriendDragableView.m
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendDragableView.h"

#import "FRDFriend.h"

@interface FRDFriendDragableView ()

@property (weak, nonatomic) IBOutlet UIImageView *friendProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendSmokerLabel;

@end

@implementation FRDFriendDragableView

#pragma mark - Actions

- (void)configureWithFriend:(FRDFriend *)friend
{
    self.friendNameLabel.text = friend.fullName;
    self.friendAgeLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)friend.age];
    self.friendDistanceLabel.text = [NSString stringWithFormat:@"%f", friend.distanceFromMe];
    self.friendSmokerLabel.text = [NSString stringWithFormat:@"%@", friend.smoker ? LOCALIZED(@"Smoker") : LOCALIZED(@"Non-Smoker")];
}

@end
