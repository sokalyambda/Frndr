//
//  FRDFriendsListController.m
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendsListController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDFriendCell.h"

@interface FRDFriendsListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *friends;

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@end

@implementation FRDFriendsListController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.friendsTableView.rowHeight = UITableViewAutomaticDimension;
        self.friendsTableView.estimatedRowHeight = 20.f;
        [self.friendsTableView reloadData];
    });
    [self.friendsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    
    self.navigationTitleView.titleText = LOCALIZED(@"Frnds");
    
    UIBarButtonItem *topIconItem = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:@selector(customPopViewController:)];
    self.navigationItem.leftBarButtonItem = topIconItem;
}

/**
 *  Custom pop controller
 *
 *  @param sender Sender (Can be a button)
 */
- (void)customPopViewController:(id)sender
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CATransition *transition = [CATransition animation];
    transition.duration = .4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.friends.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRDFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FRDFriendCell class]) forIndexPath:indexPath];
    
    [cell configureWithFriend:self.friends[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
