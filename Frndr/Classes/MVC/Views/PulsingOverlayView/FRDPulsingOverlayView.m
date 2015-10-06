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

#import "FRDAvatar.h"

static CGFloat const kDuration = .2f;

@interface FRDPulsingOverlayView ()

@property (weak, nonatomic) IBOutlet UIView *bluredView;
@property (weak, nonatomic) IBOutlet FRDRoundedImageView *avatarImageView;

@end

@implementation FRDPulsingOverlayView

#pragma mark - Actions

- (void)updatePulsingViewAvatar
{
    FRDCurrentUserProfile *profile = [FRDStorageManager sharedStorage].currentUserProfile;
    
    if (profile.currentAvatar.photoURL) {
        [self.avatarImageView sd_setImageWithURL:profile.currentAvatar.photoURL]; //avatar from server
    } else {
        [self.avatarImageView sd_setImageWithURL:profile.avatarURL]; //avatar from facebook
    }
    
    [self.avatarImageView addBorder];
}

- (IBAction)avatarClick:(id)sender
{
    [self.avatarImageView pulsingWithWavesInView:self repeating:NO];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    if (self) {
        [self addPulsingAnimations];
    }
}

#pragma mark - Public Methods

- (void)subscribeForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)unsibscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  Show or hide pulsing modal overlap view
 */
- (void)showHide
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    WEAK_SELF;
    
    if (![mainWindow.subviews containsObject:self]) {
        [self setAlpha:0.f];
        [self setFrame:mainWindow.frame];
        
        [self.bluredView blurView];
        
        [mainWindow addSubview:self];
        
        [UIView animateWithDuration:kDuration animations:^{
            [weakSelf setAlpha:1.f];
        } completion:^(BOOL finished) {
            [weakSelf.avatarImageView pulsingWithWavesInView:self.superview repeating:YES];
        }];
    } else {
        [UIView animateWithDuration:kDuration animations:^{
            weakSelf.alpha = 0.f;
        }completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }
}

/**
 *  Show overlap view
 *
 *  @param view View for presenting
 */
- (void)showInView:(UIView *)view
{
    [self cleanFromAnimations];
    WEAK_SELF;
    if (![view.subviews containsObject:self]) {
        [self setAlpha:0.f];
        [self setFrame:view.frame];
        [self.bluredView blurView];
        [view addSubview:self];
        
        [UIView animateWithDuration:kDuration animations:^{
            [weakSelf setAlpha:1.f];
            //update avatar
            [weakSelf updatePulsingViewAvatar];
        } completion:^(BOOL finished) {
            [weakSelf addPulsingAnimations];
        }];
    }
}

/**
 *  Dismiss  view from presented view
 *
 *  @param view Presented view
 */
- (void)dismissFromView:(UIView *)view
{
    [self cleanFromAnimations];
    
    WEAK_SELF;
    if ([view.subviews containsObject:self]) {
        [UIView animateWithDuration:kDuration animations:^{
            weakSelf.alpha = 0.f;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }
}

/**
 *  Configure animations and blur
 */
- (void)addPulsingAnimations
{
    [self cleanFromAnimations];
    [self.avatarImageView pulsingWithWavesInView:self repeating:YES];
    //update avatar
    [self updatePulsingViewAvatar];
}

/**
 *  Remove all animations
 */
- (void)cleanFromAnimations
{
    @autoreleasepool {
        for (CALayer *layer in self.superview.layer.sublayers) {
            [layer removeAllAnimations];
        }
    }
}

@end
