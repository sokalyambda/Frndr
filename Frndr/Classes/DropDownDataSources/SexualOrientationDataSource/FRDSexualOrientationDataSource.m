//
//  FRDSexualOrientationDataSource.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSexualOrientationDataSource.h"

#import "FRDDropDownCell.h"

#import "FRDSexualOrientation.h"

static NSString *const kSexualOrientationsPlist = @"SexualOrientations";

@interface FRDSexualOrientationDataSource ()

@property (nonatomic) NSArray *sexualOrientations;

@end

@implementation FRDSexualOrientationDataSource

#pragma mark - Accessors

- (NSArray *)sexualOrientations
{
    if (!_sexualOrientations) {
        _sexualOrientations = [self createOrientationItemsArray];
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
    FRDSexualOrientation *currentOrientation = self.sexualOrientations[indexPath.row];
    dropDownCell.textLabel.text = currentOrientation.orientationString;
}

#pragma mark - Actions

- (NSArray *)createOrientationItemsArray
{
    NSArray *orientationTitles = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kSexualOrientationsPlist ofType:@"plist"]];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *title in orientationTitles) {
        FRDSexualOrientation *orientation = [FRDSexualOrientation orientationWithOrientationString:title];
        [array addObject:orientation];
    }
    
    return array;
}

@end
