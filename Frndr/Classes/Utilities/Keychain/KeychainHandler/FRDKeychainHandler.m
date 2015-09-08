//
//  BZRKeychainHandler.m
//  BizrateRewards
//
//  Created by Eugenity on 16.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "FRDKeychainHandler.h"

#import <SSKeychain/SSKeychain.h>

@implementation FRDKeychainHandler

/**
 *  Store user private data to keychain, using the KeychainItemWrapper
 *
 *  @param username Username for storing
 *  @param password Password for storing
 */
+ (void)storeCredentialsWithUsername:(NSString*)username andPassword:(NSString*)password forService:(NSString *)serviceName
{
    if (username && password) {
        [self resetKeychainForService:serviceName];
        [SSKeychain setPassword:password forService:serviceName account:username];
    }
}

/**
 *  Get user private data from keychain
 *
 *  @return Dictionary with user private data
 */
+ (NSDictionary*)getStoredCredentialsForService:(NSString *)serviceName
{
    NSArray *accountsArray = [SSKeychain accountsForService:serviceName];
    
    NSString *accountName;
    NSString *password;
    NSDictionary *credentials;
    
    if (accountsArray.count) {
        NSDictionary *credentialsDictionary = accountsArray[0];
        accountName = credentialsDictionary[kSSKeychainAccountKey];
        password = [SSKeychain passwordForService:serviceName account:accountName];
    }

    if (password && accountName) {
        credentials = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                           accountName,
                                                           password,
                                                           nil]
                                                  forKeys:[NSArray arrayWithObjects:
                                                           [NSString stringWithFormat:UserNameKey],
                                                           [NSString stringWithFormat:PasswordKey],
                                                           nil]];
    }
    
    return credentials ?: @{UserNameKey: @"", PasswordKey: @""};
}

/**
 *  Reset keychain data
 */
+ (void)resetKeychainForService:(NSString *)serviceName
{
    NSDictionary *storedCredentials = [self getStoredCredentialsForService:serviceName];
    [SSKeychain deletePasswordForService:serviceName account:storedCredentials[UserNameKey]];
}

/**
 *  Check whether keychain contains data but app was previously deleted
 */
+ (void)resetKeychainIfFirstLaunch
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults.dictionaryRepresentation.allKeys containsObject:IsFirstLaunch]) {
        [self resetKeychainForService:UserCredentialsKey];
    }
}

@end
