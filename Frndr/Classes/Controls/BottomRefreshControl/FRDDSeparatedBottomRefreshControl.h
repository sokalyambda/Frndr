//
//  FRDBottomRefreshControlMediator.h
//  Frndr
//
//  Created by Pavlo on 10/12/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@interface FRDDSeparatedBottomRefreshControl : UIControl

@property (readonly, nonatomic) BOOL refreshing;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)beginRefreshing;
- (void)endRefreshing;

@end