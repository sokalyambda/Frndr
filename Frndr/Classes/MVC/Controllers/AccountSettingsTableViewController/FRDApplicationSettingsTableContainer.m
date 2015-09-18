//
//  FRDAccountSettingsTableViewController.m
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDApplicationSettingsTableContainer.h"

#import "FRDApplicationSettingsTableHeader.h"

typedef NS_ENUM(NSInteger, FRDApplicationSettingsSectionType)
{
    FRDApplicationSettingsSectionTypeNotifications,
    FRDApplicationSettingsSectionTypeOther
};

@interface FRDApplicationSettingsTableContainer ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorHeight;
@property (weak, nonatomic) IBOutlet UISwitch *friendSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *messageSwitch;

@end

@implementation FRDApplicationSettingsTableContainer

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerHeader];
    [self adjustTopSeparatorHeight];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - Actions

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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Prevent scrolling if content fits the screen
    if (CGRectGetMaxY(cell.frame) > CGRectGetHeight([UIScreen mainScreen].bounds)) {
        self.tableView.alwaysBounceVertical = NO;
    }
}

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
    static FRDApplicationSettingsTableHeader *header;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FRDApplicationSettingsTableHeader class])];
    });
    
    FRDApplicationSettingsSectionType sectionType = section;
    
    switch (sectionType) {
        case FRDApplicationSettingsSectionTypeNotifications: {
            return CGRectGetHeight(header.frame);
        }
            
        case FRDApplicationSettingsSectionTypeOther: {
            return CGRectGetMidY(header.bounds);
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
                break;
            }
                
            case FRDApplicationOtherSettingClearAllMessages: {
                break;
            }
                
            case FRDApplicationOtherSettingHelp: {
                break;
            }
                
            case FRDApplicationOtherSettingPrivacyPolicy: {
                break;
            }
                
            case FRDApplicationOtherSettingTermsOfService: {
                break;
            }
        }
    } else {
        FRDApplicationNotificationsSettingType notificationsSettingType = indexPath.row;
        
        switch (notificationsSettingType) {
            case FRDApplicationNotificationSettingNewFriend: {
                [self.friendSwitch setOn:!self.friendSwitch.isOn animated:YES];
                break;
            }
                
            case FRDApplicationNotificationSettingNewMessage: {
                [self.messageSwitch setOn:!self.messageSwitch.isOn animated:YES];
                break;
            }
        }
    }
}

@end
