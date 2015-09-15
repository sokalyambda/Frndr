//
//  FRDSexualOrientationDataSource.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSexualOrientationDataSource.h"

#import "FRDDropDownCell.h"

@interface FRDSexualOrientationDataSource ()

@property (nonatomic) NSArray *sexualOrientations;

@end

@implementation FRDSexualOrientationDataSource

#pragma mark - Accessors

- (NSArray *)sexualOrientations
{
    if (!_sexualOrientations) {
        _sexualOrientations = @[@"GETERO", @"BI"];
    }
    return _sexualOrientations;
}

- (NSArray *)currentDataSourceArray
{
    return self.sexualOrientations;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sexualOrientations.count;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    FRDDropDownCell *dropDownCell = (FRDDropDownCell *)cell;
    dropDownCell.textLabel.text = self.sexualOrientations[indexPath.row];
}

@end
