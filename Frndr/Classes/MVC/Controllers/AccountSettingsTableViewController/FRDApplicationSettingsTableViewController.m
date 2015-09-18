//
//  FRDAccountSettingsTableViewController.m
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDApplicationSettingsTableViewController.h"

#import "FRDAccountSettingTableViewHeader.h"

static NSInteger const kNotificationsSection = 0;
static NSInteger const kOtherSettingsSection = 1;

@interface FRDApplicationSettingsTableViewController ()

@end

@implementation FRDApplicationSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([FRDAccountSettingTableViewHeader class]) bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:NSStringFromClass([FRDAccountSettingTableViewHeader class])];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Prevent scrolling if content fits the screen
    if (CGRectGetMaxY(cell.frame) < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        self.tableView.alwaysBounceVertical = NO;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == kNotificationsSection) {
        return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FRDAccountSettingTableViewHeader class])];
    } else {
        // Make this header, because there is space between sections on design
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  CGRectGetWidth(self.tableView.frame),
                                                                  tableView.sectionHeaderHeight)];
        
        // Place this view at the bottom of the header so it'll look like Top Separator
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(header.frame),
                                                                     CGRectGetWidth(self.tableView.frame),
                                                                     // Make separator 1 pixel (not point) tall
                                                                     1.0 / [UIScreen mainScreen].scale)];

        separator.backgroundColor = self.tableView.separatorColor;
        [header addSubview:separator];
        
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    static FRDAccountSettingTableViewHeader *header;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FRDAccountSettingTableViewHeader class])];
    });
    
    if (section == kNotificationsSection) {
        return CGRectGetHeight(header.frame);
    } else {
        // Make header look like top separator
        return CGRectGetMidY(header.bounds);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FRDApplicationSettingType settingType = -1;
    if (indexPath.section == kOtherSettingsSection) {
        settingType = indexPath.row;
    }
    
    switch (settingType) {
        case FRDApplicationSettingTypeDeleteAccount: {
            break;
        }
            
        case FRDApplicationSettingTypeClearAllMessages: {
            break;
        }
            
        case FRDApplicationSettingTypeHelp: {
            break;
        }
            
        case FRDApplicationSettingTypePrivacyPolicy: {
            break;
        }
            
        case FRDApplicationSettingTypeTermsOfService: {
            break;
        }
            
        default:
            break;
    }
}

@end
