//
//  FRDPulsingOverlayView.m
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPulsingOverlayView.h"
#import "FRDRoundedImageView.h"

#import "UIView+Pulsing.h"
#import "UIView+Bluring.h"

static CGFloat const kDuration = .2f;

@interface FRDPulsingOverlayView ()

@property (weak, nonatomic) IBOutlet UIView *bluredView;
@property (weak, nonatomic) IBOutlet FRDRoundedImageView *avatarImageView;

@end

@implementation FRDPulsingOverlayView

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
    [self commonInit];
}

#pragma mark - Actions

- (void)commonInit
{
    FRDCurrentUserProfile *profile = [FRDStorageManager sharedStorage].currentUserProfile;
    [self.avatarImageView sd_setImageWithURL:profile.avatarURL];
}

/**
 *  Show or hide pulsing overlap view
 */
- (void)showHide
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    WEAK_SELF;
    
    if (![mainWindow.subviews containsObject:self]) {
        
        [self setAlpha:0.f];
        [self setFrame:mainWindow.frame];
        [mainWindow addSubview:self];
        
        [self setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];
        
        [UIView animateWithDuration:kDuration animations:^{
            [weakSelf setTransform:CGAffineTransformMakeScale(1.f, 1.f)];
            [weakSelf setAlpha:1.f];
            [weakSelf.bluredView blurView];
            
        } completion:^(BOOL finished) {
            if (finished) {
                [weakSelf.avatarImageView pulsingWithWavesInView:self.superview repeating:YES];
            }
        }];

    } else {
        [UIView animateWithDuration:kDuration animations:^{
            [weakSelf setTransform:CGAffineTransformMakeScale(2.f, 2.f)];
            weakSelf.alpha = 0.f;
        }completion:^(BOOL finished) {
            if (finished) {
                [weakSelf setTransform:CGAffineTransformMakeScale(1.f, 1.f)];
                [weakSelf removeFromSuperview];
            }
        }];
    }
}

- (IBAction)avatarClick:(id)sender
{
    [self.avatarImageView pulsingWithWavesInView:self.superview repeating:NO];
}

@end
