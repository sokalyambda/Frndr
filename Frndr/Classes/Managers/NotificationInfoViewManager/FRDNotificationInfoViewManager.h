//
//  FRDNotificationInfoViewManager.h
//  Frndr
//
//  Created by Eugenity on 16.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@class FRDNotificationInfoView;

@interface FRDNotificationInfoViewManager : NSObject

+ (FRDNotificationInfoViewManager *)sharedManager;

- (void)showNotificationView:(FRDNotificationInfoView *)infoView;

@end
