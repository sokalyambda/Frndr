//
//  FRDPreferencesTableViewController.m
//  Frndr
//
//  Created by Pavlo on 9/9/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPreferencesTableViewController.h"

@implementation FRDPreferencesTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

@end
