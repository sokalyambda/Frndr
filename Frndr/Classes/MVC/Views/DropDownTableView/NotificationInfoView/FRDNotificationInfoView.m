//
//  FRDNotificationInfoView.m
//  Frndr
//
//  Created by Eugenity on 16.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNotificationInfoView.h"

#import "FRDRemoteNotification.h"
#import "FRDFriend.h"

static CGFloat const kDropDownHeight = 84.f;

@interface FRDNotificationInfoView ()

@property (weak, nonatomic) IBOutlet UIView *infoHolder;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;

@property (weak, nonatomic) IBOutlet UIImageView *currentFriendAvatar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FRDNotificationInfoView

#pragma mark - Accessors

- (void)setCurrentNotification:(FRDRemoteNotification *)currentNotification
{
    FRDFriend *currentFriend = currentNotification.currentFriend;
    [self.currentFriendAvatar sd_setImageWithURL:currentFriend.avatarURL];
    self.titleLabel.text = currentNotification.notificationTitle;
    _currentNotification = currentNotification;
}

#pragma mark - Drop Down Actions

- (void)showDropDownList
{
    [_presentedView addSubview:self];
    [self layoutIfNeeded];
    
    //dd in moving now
    self.isMoving = YES;
    
    //dd will be presented
    if (_presentingCompletion) {
        self.isExpanded = YES;
        _presentingCompletion(self);
    }
    
    WEAK_SELF;
    [UIView animateWithDuration:self.slideAnimationDuration
                          delay:.1f
         usingSpringWithDamping:.6f
          initialSpringVelocity:.6f
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            CGRect newFrame = weakSelf.frame;
                            newFrame.size.height = kDropDownHeight;
                            weakSelf.frame = newFrame;
                            weakSelf.infoHolder.frame = newFrame;
                            [weakSelf layoutIfNeeded];
                        }
     
                     completion:^(BOOL finished) {
                         weakSelf.isMoving = NO;
                     }];
}

- (void)hideDropDownList
{
    [self layoutIfNeeded];
    //dd in moving now
    self.isMoving = YES;
    
    if (_presentingCompletion) {
        self.isExpanded = NO;
        _presentingCompletion(self);
    }
    
    WEAK_SELF;
    [UIView animateWithDuration:self.slideAnimationDuration
                          delay:0.1f
         usingSpringWithDamping:1.f
          initialSpringVelocity:1.f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            weakSelf.frame = savedDropDownTableFrame;
                            [weakSelf layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                         _anchorView = nil;
                         _dropDownDataSource = nil;
                         [weakSelf removeFromSuperview];
                         
                         weakSelf.isMoving = NO;
                     }];
}

#pragma mark - Actions

- (IBAction)openChatClick:(id)sender
{
    [self hideDropDownList];
    
    if ([self.delegate respondsToSelector:@selector(notificationViewDidTapOpenChatButton:)]) {
        [self.delegate notificationViewDidTapOpenChatButton:self];
    }
}

- (void)swiped
{
    [self hideDropDownList];
}

- (void)commonInit
{
    [super commonInit];
    if (![self.gestureRecognizers containsObject:self.swipeGesture]) {
        self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped)];
        self.swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:self.swipeGesture];
    }
}

@end
