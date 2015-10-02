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

@property (weak, nonatomic) IBOutlet FRDRoundedImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (nonatomic) FRDChatCellPositionInSet positionInSet;

@end

@implementation FRDUserChatCell

#pragma mark - Accessors



#pragma mark - Lifecycle

- (void)awakeFromNib
{
    FRDCurrentUserProfile *profile = [FRDStorageManager sharedStorage].currentUserProfile;
    [self.avatarImageView sd_setImageWithURL:profile.avatarURL];
}

#pragma mark - Actions

- (void)updateWithPositionInSet:(FRDChatCellPositionInSet)position
{
    switch (position) {
        case FRDChatCellPositionInSetFirst: {
            
            break;
        }
           
        case FRDChatCellPositionInSetIntermediary: {
            break;
        }
            
        case FRDChatCellPositionInSetLast: {
            break;
        }
            
        default:
            break;
    }
}

@end
