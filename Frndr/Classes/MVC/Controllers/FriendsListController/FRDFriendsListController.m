//
//  FRDFriendsListController.m
//  Frndr
//
//  Created by Eugenity on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendsListController.h"
#import "FRDChatController.h"

#import "FRDSerialViewConstructor.h"

#import "FRDFriendCell.h"

#import "FRDProjectFacade.h"

#import "FRDChatMessagesService.h"

@interface FRDFriendsListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *friends;

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation FRDFriendsListController

#pragma mark - Accessors

- (NSString *)titleString
{
    return @"Frnds";
}

- (NSString *)leftImageName
{
    return @"preferencesTopIcon";
}

- (NSString *)rightImageName
{
    return @"";
}

- (NSMutableArray *)friends
{
    if (!_friends) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _currentPage = 1;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.friendsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self loadFriendsList];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
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
    
    FRDFriend *currentFriend = self.friends[indexPath.row];
    
    FRDChatController *chatController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FRDChatController class])];
    chatController.currentFriend = currentFriend;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)updateLocalFriendsArrayWithArray:(NSArray *)newArray
{
    [self.friends addObjectsFromArray:newArray];
    [self.friendsTableView reloadData];
}

/**
 *  Load more friends relative to current page
 */
- (void)loadFriendsList
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FRDProjectFacade getFriendsListWithPage:self.currentPage onSuccess:^(NSArray *friendsList) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (friendsList.count) {
            [weakSelf updateLocalFriendsArrayWithArray:friendsList];
            weakSelf.currentPage++;
            
            
            
            //temp test
//            [FRDChatMessagesService sendMessage:@"Hi again, I want to write you a long long long long long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long longlong long long message " toFriendWithId:@"560e7804b03a75135dc091e7" onSuccess:^(BOOL isSuccess) {
//                NSLog(@"message has been sent");
//            } onFailure:^(NSError *error, BOOL isCanceled) {
//                NSLog(@"!!!!!message hasn't been sent!!!!!");
//            }];
            
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [FRDAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
    }];
}

@end
