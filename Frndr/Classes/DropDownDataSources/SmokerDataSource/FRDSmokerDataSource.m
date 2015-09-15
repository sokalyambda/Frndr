//
//  FRDSmokerDataSource.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSmokerDataSource.h"

#import "FRDDropDownCell.h"

@interface FRDSmokerDataSource ()

@property (nonatomic) NSArray *smokerTypes;

@end

@implementation FRDSmokerDataSource

#pragma mark - Accessors

- (NSArray *)smokerTypes
{
    if (!_smokerTypes) {
        _smokerTypes = @[@"SMOKER", @"NOT A SMOKER"];
    }
    return _smokerTypes;
}

- (NSArray *)currentDataSourceArray
{
    return self.smokerTypes;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.smokerTypes.count;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    FRDDropDownCell *dropDownCell = (FRDDropDownCell *)cell;
    dropDownCell.textLabel.text = self.smokerTypes[indexPath.row];
}

@end
