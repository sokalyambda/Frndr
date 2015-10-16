//
//  FRDNotificationInfoView.h
//  Frndr
//
//  Created by Eugenity on 16.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDDropDownTableView.h"

@class FRDRemoteNotification;
@protocol FRDNotificationInfoViewDelegate;

@interface FRDNotificationInfoView : FRDDropDownTableView

@property (strong, nonatomic) FRDRemoteNotification *currentNotification;

@property (weak, nonatomic) id<FRDNotificationInfoViewDelegate> delegate;

@end

@protocol FRDNotificationInfoViewDelegate <NSObject>

@optional
- (void)notificationViewDidTapOpenChatButton:(FRDNotificationInfoView *)infoView;

@end
