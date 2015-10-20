//
//  FRDNotificationInfoViewManager.h
//  Frndr
//
//  Created by Eugenity on 16.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNotificationInfoView.h"

@interface FRDNotificationInfoViewManager : NSObject

+ (FRDNotificationInfoViewManager *)sharedManager;

- (void)showNotificationView:(FRDNotificationInfoView *)infoView;
- (void)hideNotificationInfoView;

@end
