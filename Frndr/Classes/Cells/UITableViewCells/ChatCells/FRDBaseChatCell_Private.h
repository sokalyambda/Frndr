//
//  FRDBaseChatCell_Private.h
//  Frndr
//
//  Created by Pavlo on 10/5/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseChatCell.h"

#import "FRDRoundedImageView.h"

@interface FRDBaseChatCell ()

@property (weak, nonatomic) IBOutlet FRDRoundedImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;

@end
