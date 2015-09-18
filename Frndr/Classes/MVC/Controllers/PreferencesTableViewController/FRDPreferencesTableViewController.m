//
//  FRDPreferencesTableViewController.m
//  Frndr
//
//  Created by Pavlo on 9/9/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPreferencesTableViewController.h"
#import "FRDSearchSettingsController.h"
#import "FRDApplicationSettingsController.h"

@implementation FRDPreferencesTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Prevent scrolling if content fits the screen
    if (CGRectGetMaxY(cell.frame) > CGRectGetHeight([UIScreen mainScreen].bounds)) {
        self.tableView.alwaysBounceVertical = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FRDPreferenceType prefType = indexPath.row;
    
    switch (prefType) {
        case FRDPreferenceTypeSearchSettings: {
            FRDSearchSettingsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDSearchSettingsController class])];
            [self.parentViewController.navigationController pushViewController:controller animated:YES];
            break;
        }
        case FRDPreferenceTypeMyProfile: {
            break;
        }
        case FRDPreferenceTypeSettings: {
            FRDApplicationSettingsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDApplicationSettingsController class])];
            [self.parentViewController.navigationController pushViewController:controller animated:YES];
            break;
        }
        case FRDPreferenceTypeShareFrndr: {
            break;
        }
            
        default:
            break;
    }
}

@end
