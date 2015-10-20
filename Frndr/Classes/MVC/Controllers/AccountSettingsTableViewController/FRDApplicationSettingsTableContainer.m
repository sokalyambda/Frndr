//
//  FRDAccountSettingsTableViewController.m
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDApplicationSettingsTableContainer.h"
#import "FRDBaseViewController.h"
#import "FRDTutorialController.h"

#import "FRDApplicationSettingsTableHeader.h"
#import "FRDSwitch.h"

#import "FRDProjectFacade.h"

#import "FRDRedirectionHelper.h"

typedef NS_ENUM(NSInteger, FRDApplicationSettingsSectionType)
{
    FRDApplicationSettingsSectionTypeNotifications,
    FRDApplicationSettingsSectionTypeOther
};

@interface FRDApplicationSettingsTableContainer ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorHeight;
@property (weak, nonatomic) IBOutlet FRDSwitch *friendSwitch;
@property (weak, nonatomic) IBOutlet FRDSwitch *messageSwitch;

@end

@implementation FRDApplicationSettingsTableContainer

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerHeader];
    [self adjustTopSeparatorHeight];
    
    [self configureTableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performUpdatingActions];
    });
}

#pragma mark - Actions

- (IBAction)newFriendsNotificationsClick:(id)sender
{
    [FRDStorageManager sharedStorage].currentUserProfile.friendsNotificationsEnabled = self.friendSwitch.isOn;
    [self updateNotificationsSettings];
}

- (IBAction)newMessagesNotificationsClick:(id)sender
{
    [FRDStorageManager sharedStorage].currentUserProfile.messagesNotificationsEnabled = self.messageSwitch.isOn;
    [self updateNotificationsSettings];
}

- (void)registerHeader
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([FRDApplicationSettingsTableHeader class]) bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:NSStringFromClass([FRDApplicationSettingsTableHeader class])];
}

- (void)configureTableView
{
    self.tableView.tableHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FRDApplicationSettingsTableHeader class])];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.alwaysBounceVertical = NO;
}

/**
 *  Make top separator 1 pixel tall
 */
- (void)adjustTopSeparatorHeight
{
    self.topSeparatorHeight.constant = 1.0 / [UIScreen mainScreen].scale;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FRDApplicationSettingsSectionType sectionType = section;
    
    switch (sectionType) {
        case FRDApplicationSettingsSectionTypeNotifications: {
            return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FRDApplicationSettingsTableHeader class])];
        }
            
        case FRDApplicationSettingsSectionTypeOther: {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    FRDApplicationSettingsSectionType sectionType = section;
    
    switch (sectionType) {
        case FRDApplicationSettingsSectionTypeNotifications: {
            return 0.f;
        }
            
        case FRDApplicationSettingsSectionTypeOther: {
            return CGRectGetMidY(tableView.tableHeaderView.frame);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FRDApplicationSettingsSectionType sectionType = indexPath.section;
    
    if (sectionType == FRDApplicationSettingsSectionTypeOther) {
        FRDApplicationOtherSettingType otherSettingType = indexPath.row;
        
        switch (otherSettingType) {
            case FRDApplicationOtherSettingDeleteAccount: {
                [self showDeleteAccountActionSheet];
                break;
            }
                
            case FRDApplicationOtherSettingClearAllMessages: {
                [self showClearAllMessagesActionSheet];
                break;
            }
                
            case FRDApplicationOtherSettingHelp: {
                FRDTutorialController *tutorialController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDTutorialController class])];
                tutorialController.redirectedFromHelp = YES;
                [self.parentViewController presentViewController:tutorialController animated:YES completion:nil];
                break;
            }
                
            case FRDApplicationOtherSettingPrivacyPolicy: {
                [FRDRedirectionHelper redirectToTermsAndServicesWithURI:PrivacyPolicyResourceName title:@"Privacy Policy" andPresentingController:(FRDBaseViewController *)self.parentViewController];
                break;
            }
                
            case FRDApplicationOtherSettingTermsOfService: {
                [FRDRedirectionHelper redirectToTermsAndServicesWithURI:TermsOfServiceResourceName title:@"Terms of Service" andPresentingController:(FRDBaseViewController *)self.parentViewController];
                break;
            }
        }
    } else {
        FRDApplicationNotificationsSettingType notificationsSettingType = indexPath.row;
        
        switch (notificationsSettingType) {
            case FRDApplicationNotificationSettingNewFriend: {
                [self.friendSwitch setOn:!self.friendSwitch.isOn animated:YES];
                [FRDStorageManager sharedStorage].currentUserProfile.friendsNotificationsEnabled = self.friendSwitch.isOn;
                [self updateNotificationsSettings];
                break;
            }
                
            case FRDApplicationNotificationSettingNewMessage: {
                [self.messageSwitch setOn:!self.messageSwitch.isOn animated:YES];
                [FRDStorageManager sharedStorage].currentUserProfile.messagesNotificationsEnabled = self.messageSwitch.isOn;
                [self updateNotificationsSettings];
                break;
            }
        }
    }
}

- (void)performUpdatingActions
{
    BOOL isUserUpdateNeeded = [FRDStorageManager sharedStorage].isUserProfileUpdateNeeded;
    
    if (isUserUpdateNeeded) {
        [self getCurrentUserProfile];
    } else {
        [self updateNotificationsSettingsSwitches];
    }
}

/**
 *  Get current user profile
 */
- (void)getCurrentUserProfile
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    [FRDProjectFacade getCurrentUserProfileOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        
        [FRDStorageManager sharedStorage].userProfileUpdateNeeded = NO;
        
        [weakSelf updateNotificationsSettingsSwitches];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Update notifications settings switches
 */
- (void)updateNotificationsSettingsSwitches
{
    FRDCurrentUserProfile *currentProfile = [FRDStorageManager sharedStorage].currentUserProfile;
    [self.friendSwitch setOn:currentProfile.friendsNotificationsEnabled animated:NO];
    [self.messageSwitch setOn:currentProfile.messagesNotificationsEnabled animated:NO];
}

/**
 *  Show delete account action sheet
 */
- (void)showDeleteAccountActionSheet
{
    UIAlertController *signOutController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Do you want to delete your account?") preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *deleteAccountAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Delete profile") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf deleteAccount];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [signOutController addAction:deleteAccountAction];
    [signOutController addAction:cancelAction];
    
    [self presentViewController:signOutController animated:YES completion:nil];
}

/**
 *  Show clear all messages action sheet
 */
- (void)showClearAllMessagesActionSheet
{
    UIAlertController *signOutController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Do you want to clear all messages?") preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *clearMessagesAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Clear messages") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf clearMessages];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [signOutController addAction:clearMessagesAction];
    [signOutController addAction:cancelAction];
    
    [self presentViewController:signOutController animated:YES completion:nil];
}

/**
 *  Clear all messages
 */
- (void)clearMessages
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    [FRDProjectFacade clearAllMessagesOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        [FRDAlertFacade showAlertWithMessage:LOCALIZED(@"All messages have been removed.") forController:weakSelf withCompletion:nil];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Delete account
 */
- (void)deleteAccount
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    [FRDProjectFacade deleteAccountOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        
        [FRDStorageManager sharedStorage].userProfileUpdateNeeded = YES;
        [FRDStorageManager sharedStorage].searchSettingsUpdateNeeded = YES;
        
        [weakSelf.parentViewController.navigationController popToRootViewControllerAnimated:YES];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

/**
 *  Update current notifications settingss
 */
- (void)updateNotificationsSettings
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    [FRDProjectFacade updateNotificationsSettingsOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

@end
