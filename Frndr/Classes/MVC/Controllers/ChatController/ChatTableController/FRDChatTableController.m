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

@property (strong, nonatomic) NSMutableArray *messageHistory;

@end

@implementation FRDChatTableController

#pragma mark - Accessors 

- (void)setMessageHistory:(NSMutableArray *)messageHistory
{
    _messageHistory = [messageHistory mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 10.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Actions

- (IBAction)loadMoreMessages:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}

- (void)addCellWithMessage:(NSString *)message andType:(FRDChatCellType)type
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.messageHistory.count;
    return 15;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRDBaseChatCell *cell;
    
    NSInteger i = indexPath.row % 4;
    
    if (i == 0) {
        cell = [FRDBaseChatCell chatCellWithType:(FRDChatCellType)0];
        cell.message = @"I'm trying to create a UIPickerView with some";
        cell.timeStamp = [NSDate date];
        cell.positionInSet = FRDChatCellPositionInSetFirst;
    } else if (i == 1) {
        cell = [FRDBaseChatCell chatCellWithType:(FRDChatCellType)1];
        cell.message = @"i tried to use the above 2 modes";
        cell.timeStamp = [NSDate date];
        cell.positionInSet = FRDChatCellPositionInSetIntermediary;
    } else if (i == 2) {
        cell = [FRDBaseChatCell chatCellWithType:(FRDChatCellType)0];
        cell.message = @"ScaleToFill This will";
        cell.timeStamp = [NSDate date];
        cell.positionInSet = FRDChatCellPositionInSetLast;
    } else {
        cell = [FRDBaseChatCell chatCellWithType:(FRDChatCellType)2];
        cell.message = @"ScaleToFill This will";
        cell.timeStamp = [NSDate date];
    }
    
    return cell;
}

@end
