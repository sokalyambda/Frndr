//
//  FRDAccountSettingsTableViewController.m
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDApplicationSettingsTableContainer.h"
#import "FRDBaseViewController.h"

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
    
    self.tableView.tableHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FRDApplicationSettingsTableHeader class])];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.alwaysBounceVertical = NO;
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
                break;
            }
                
            case FRDApplicationOtherSettingHelp: {
                break;
            }
                
            case FRDApplicationOtherSettingPrivacyPolicy: {
                [FRDRedirectionHelper redirectToTermsAndServicesWithURL:[NSURL URLWithString:@"http://Privacy policy URL"] andPresentingController:(FRDBaseViewController *)self.parentViewController];
                break;
            }
                
            case FRDApplicationOtherSettingTermsOfService: {
                [FRDRedirectionHelper redirectToTermsAndServicesWithURL:[NSURL URLWithString:@"http://Terms of services URL"] andPresentingController:(FRDBaseViewController *)self.parentViewController];
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
 *  Delete account
 */
- (void)deleteAccount
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    [FRDProjectFacade deleteAccountOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        
        [weakSelf.parentViewController.navigationController popToRootViewControllerAnimated:YES];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentViewController.view animated:YES];
        
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
//        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

@end
