//
//  FRDAccountSettingsTableViewController.h
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRDApplicationSettingType)
{
    FRDApplicationSettingTypeDeleteAccount,
    FRDApplicationSettingTypeClearAllMessages,
    FRDApplicationSettingTypeHelp,
    FRDApplicationSettingTypePrivacyPolicy,
    FRDApplicationSettingTypeTermsOfService
};

@interface FRDApplicationSettingsTableViewController : UITableViewController

@end
