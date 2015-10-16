//
//  FRDBottomRefreshControlMediator.h
//  Frndr
//
//  Created by Pavlo on 10/12/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@interface FRDSeparatedBottomRefreshControl : UIControl

@property (readonly, nonatomic, getter=isRefreshing) BOOL refreshing;
@property (nonatomic) CGFloat additionalVerticalInset;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)beginRefreshing;
- (void)endRefreshing;

@end