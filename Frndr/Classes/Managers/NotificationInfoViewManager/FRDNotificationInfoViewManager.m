//
//  FRDNotificationInfoViewManager.m
//  Frndr
//
//  Created by Eugenity on 16.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNotificationInfoViewManager.h"

#import "FRDPushNotifiactionService.h"

#import "FRDRemoteNotification.h"
#import "FRDFriend.h"

@interface FRDNotificationInfoViewManager ()<FRDNotificationInfoViewDelegate>

@property (strong, nonatomic) FRDNotificationInfoView *notificationInfoView;

@end

@implementation FRDNotificationInfoViewManager

#pragma mark - Lifecycle

+ (FRDNotificationInfoViewManager *)sharedManager;
{
    static FRDNotificationInfoViewManager *manager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark - Actions

- (void)showNotificationView:(FRDNotificationInfoView *)infoView
{
    if (!self.notificationInfoView) {
        
        self.notificationInfoView = infoView;
        self.notificationInfoView.delegate = self;
        
        WEAK_SELF;
        [infoView dropDownTableBecomeActiveInView:[UIApplication sharedApplication].keyWindow fromAnchorView:nil withDataSource:nil withShowingCompletion:^(FRDDropDownTableView *table) {
            
            if (table.isExpanded) {
                [weakSelf performSelector:@selector(hideNotificationInfoView) withObject:nil afterDelay:4.f];
            }
            
        } withCompletion:nil];
    }
}

/**
 *  Hide notification view if needed
 */
- (void)hideNotificationInfoView
{
    if (self.notificationInfoView) {
        [self.notificationInfoView hideDropDownList];
        self.notificationInfoView = nil;
    }
}

#pragma mark - FRDNotificationInfoViewDelegate

- (void)notificationViewDidTapOpenChatButton:(FRDNotificationInfoView *)infoView
{
    if (infoView.currentNotification) {
        [FRDPushNotifiactionService checkForRedirectionWithCurrentFriend:self.notificationInfoView.currentNotification.currentFriend];
    }
}

@end
