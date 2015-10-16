//
//  FRDNotificationInfoViewManager.m
//  Frndr
//
//  Created by Eugenity on 16.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNotificationInfoViewManager.h"

#import "FRDPushNotifiactionService.h"

#import "FRDNotificationInfoView.h"

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
        [infoView dropDownTableBecomeActiveInView:[UIApplication sharedApplication].keyWindow fromAnchorView:nil withDataSource:nil withShowingCompletion:^(FRDDropDownTableView *table) {
            
            if (table.isExpanded) {
                [self performSelector:@selector(hideNotificationInfoView:) withObject:infoView afterDelay:5.f];
            }
            
        } withCompletion:nil];
    }
}

- (void)hideNotificationInfoView:(FRDNotificationInfoView *)infoView
{
    [infoView hideDropDownList];
    self.notificationInfoView = nil;
}

#pragma mark - FRDNotificationInfoViewDelegate

- (void)notificationViewDidTapOpenChatButton:(FRDNotificationInfoView *)infoView
{
    [FRDPushNotifiactionService checkForRedirectionWithCurrentFriend:self.notificationInfoView.currentNotification.currentFriend];
}

@end
