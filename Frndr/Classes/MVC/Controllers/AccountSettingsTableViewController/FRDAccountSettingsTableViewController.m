//
//  FRDAccountSettingsTableViewController.m
//  Frndr
//
//  Created by Pavlo on 9/18/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDAccountSettingsTableViewController.h"

#import "FRDAccountSettingTableViewHeader.h"

@interface FRDAccountSettingsTableViewController ()

@end

@implementation FRDAccountSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([FRDAccountSettingTableViewHeader class]) bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:NSStringFromClass([FRDAccountSettingTableViewHeader class])];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        FRDAccountSettingTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FRDAccountSettingTableViewHeader class])];
        
        return header;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    static FRDAccountSettingTableViewHeader *header;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FRDAccountSettingTableViewHeader class])];
    });
    
    if (section == 0) {
        return CGRectGetHeight(header.frame);
    } else {
        return 0;
    }
}

@end
