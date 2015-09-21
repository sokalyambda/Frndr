//
//  FRDTopContentView.m
//  Frndr
//
//  Created by Eugenity on 21.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDTopContentView.h"

@interface FRDTopContentView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@end

@implementation FRDTopContentView

#pragma mark - Accessors

- (void)setTopTitleText:(NSString *)topTitleText
{
    _topTitleText = topTitleText;
    _titleLabel.text = _topTitleText;
    _titleLabel.textColor = UIColorFromRGB(0x58406B);
    _titleLabel.font = [UIFont fontWithName:@"GillSans" size:25.f];
}

- (void)setLeftIconName:(NSString *)leftIconName
{
    _leftIconName = leftIconName;
    _leftIcon.image = [UIImage imageNamed:_leftIconName];
}

- (void)setRightIconName:(NSString *)rightIconName
{
    _rightIconName = rightIconName;
    _rightIcon.image = [UIImage imageNamed:_rightIconName];
}

#pragma mark - Actions

- (IBAction)leftItemClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(topContentView:didPressItemWithType:)]) {
        [self.delegate topContentView:self didPressItemWithType:FRDTopViewActionTypeLeftIcon];
    }
}

- (IBAction)rightItemClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(topContentView:didPressItemWithType:)]) {
        [self.delegate topContentView:self didPressItemWithType:FRDTopViewActionTypeRightIcon];
    }
}

@end
