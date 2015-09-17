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
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    
    self.navigationTitleView.titleText = LOCALIZED(@"Frnds");
    
    UIBarButtonItem *topIconItem = [FRDSerialViewConstructor customRightBarButtonForController:self withAction:nil];
    self.navigationItem.rightBarButtonItem = topIconItem;
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
