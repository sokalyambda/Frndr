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
#import "FRDMyProfileController.h"

static CGFloat const kDefaultRowHeight = 70.f;
static NSInteger const kNumberOfPreferences = 4;

static NSString * kShareMessage = @"Sharing from Frndr!";

@implementation FRDPreferencesTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - UITableViewDelegate

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
            FRDMyProfileController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDMyProfileController class])];
            controller.currentFriend = nil;
            [self.parentViewController.navigationController pushViewController:controller animated:YES];
            break;
        }
        case FRDPreferenceTypeSettings: {
            FRDApplicationSettingsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDApplicationSettingsController class])];
            [self.parentViewController.navigationController pushViewController:controller animated:YES];
            break;
        }
        case FRDPreferenceTypeShareFrndr: {
            [self showActivityViewController];
            break;
        }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(CGRectGetHeight(self.view.frame) < kDefaultRowHeight * kNumberOfPreferences) {
        return CGRectGetHeight(self.view.frame) / kNumberOfPreferences;
    } else {
        return kDefaultRowHeight;
    }
}

#pragma mark - Actions

- (void)showActivityViewController
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[kShareMessage]applicationActivities:nil];

    //activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    activityViewController.completionWithItemsHandler = ^void(NSString * __nullable activityType,
                                                              BOOL completed,
                                                              NSArray * __nullable returnedItems,
                                                              NSError * __nullable activityError) {
        NSLog(@"Activity type: %@", activityType);
        NSLog(@"Activity controller completed? - %d", completed);
        NSLog(@"Returned items: %@", returnedItems);
    };
    
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

@end
