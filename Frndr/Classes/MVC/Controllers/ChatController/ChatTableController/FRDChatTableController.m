//
//  FRDChatTableController.m
//  Frndr
//
//  Created by Pavlo on 10/5/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatTableController.h"

#import "FRDBaseChatCell.h"

@interface FRDChatTableController ()

@property (strong, nonatomic) NSArray *messageHistory;

@end

@implementation FRDChatTableController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 50.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Actions

- (void)addCellWithMessage:(NSString *)message andType:(FRDChatCellType)type
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.messageHistory.count;
    return 10;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRDBaseChatCell *cell;
    
    NSInteger i = indexPath.row % 3;
    
    if (i == 0) {
        cell = [FRDBaseChatCell chatCellWithType:(FRDChatCellType)i];
        [cell configureWithMessage:@"Message from User: Hi from user!" timeStamp:[NSDate date] positionInSet:FRDChatCellPositionInSetFirst];
    } else if (i == 1) {
        cell = [FRDBaseChatCell chatCellWithType:(FRDChatCellType)i];
        [cell configureWithMessage:@"Message from Friend: Hi from friend!" timeStamp:[NSDate date] positionInSet:FRDChatCellPositionInSetFirst];
    } else if (i == 2) {
        cell = [FRDBaseChatCell chatCellWithType:(FRDChatCellType)i];
        [cell configureWithMessage:@"Message from System: Hi from system!" timeStamp:[NSDate date] positionInSet:FRDChatCellPositionInSetFirst];
    }
    
    return cell;
}

@end
