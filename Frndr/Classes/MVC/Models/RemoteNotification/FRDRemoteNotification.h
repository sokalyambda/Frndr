//
//  FRDRemoteNotification.h
//  Frndr
//
//  Created by Eugenity on 15.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSUInteger, FRDRemoteNotificationType) {
    FRDRemoteNotificationTypeNewFriend,
    FRDRemoteNotificationTypeNewMessage
};

@class FRDFriend;

@interface FRDRemoteNotification : NSObject

@property (strong, nonatomic) FRDFriend *currentFriend;
@property (assign, nonatomic) FRDRemoteNotificationType notificationType;

@end
