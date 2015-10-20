//
//  FRDGlobalConstants.h
//  Frndr
//
//  Created by Eugenity on 30.06.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#ifndef Frndr_FRDGlobalConstants_h
#define Frndr_FRDGlobalConstants_h

//Keychain service keys
static NSString *const UserNameKey          = @"UsernameKey";
static NSString *const PasswordKey          = @"PasswordKey";
static NSString *const UserCredentialsKey   = @"UserCredentialsKey";
static NSString *const IsFirstLaunch        = @"IsFirstLaunch";

//Facebook
static NSString *const FBLoginSuccess = @"FBLoginSuccess";
static NSString *const FBAccessTokenExpirationDate = @"FBAccessTokenExpirationDate";
static NSString *const FBAccessToken = @"FBAccessToken";
static NSString *const FBCurrentProfile = @"FBCurrentProfile";

//Notifications
static NSString *const DidReceiveNewMessageNotification = @"DidReceiveNewMessageNotification";
static NSString *const NewFriendAddedNotification = @"NewFriendAddedNotification";
static NSString *const FriendDeletedNotification = @"FriendDeletedNotification";

static NSString *const PrivacyPolicyResourceName = @"PrivacyPolicy.txt";
static NSString *const TermsOfServiceResourceName = @"TermsOfService.txt";

#endif
