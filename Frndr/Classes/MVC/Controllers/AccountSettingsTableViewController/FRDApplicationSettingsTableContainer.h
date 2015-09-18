//
//  FRDAccountSettingsTableViewController.h
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRDApplicationOtherSettingType)
{
    FRDApplicationOtherSettingDeleteAccount,
    FRDApplicationOtherSettingClearAllMessages,
    FRDApplicationOtherSettingHelp,
    FRDApplicationOtherSettingPrivacyPolicy,
    FRDApplicationOtherSettingTermsOfService
};

typedef NS_ENUM(NSInteger, FRDApplicationNotificationsSettingType)
{
    FRDApplicationNotificationSettingNewFriend,
    FRDApplicationNotificationSettingNewMessage
};

@interface FRDApplicationSettingsTableContainer : UITableViewController

@end
