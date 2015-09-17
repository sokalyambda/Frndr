//
//  FRDFriendOverlayView.m
//  Frndr
//
//  Created by Eugenity on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendOverlayView.h"

@interface FRDFriendOverlayView ()

@property (weak, nonatomic) IBOutlet UIImageView *currentOverlayImageView;

@end

@implementation FRDFriendOverlayView

#pragma mark - Accessors

- (void)setCurrentOverlayImageName:(NSString *)currentOverlayImageName
{
    _currentOverlayImageName = currentOverlayImageName;
    self.currentOverlayImageView.image = [UIImage imageNamed:_currentOverlayImageName];
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

- (void)commonInit
{

}

@end
