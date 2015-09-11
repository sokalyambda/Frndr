//
//  FRDNavigationTitleView.m
//  Frndr
//
//  Created by Eugenity on 11.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNavigationTitleView.h"

@interface FRDNavigationTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FRDNavigationTitleView

#pragma mark - Accessors

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    _titleLabel.text = _titleText;
    _titleLabel.textColor = UIColorFromRGB(0x58406B);
}

@end
