//
//  FRDBaseDropDownDataSource.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDBaseDropDownDataSource.h"

#import "FRDSmokerDataSource.h"
#import "FRDSexualOrientationDataSource.h"

#import "FRDDropDownCell.h"

@interface FRDBaseDropDownDataSource ()

@property (nonatomic) NSArray *currentDataSourceArray;

@end

@implementation FRDBaseDropDownDataSource

#pragma mark - Lifecycle

- (instancetype)initWithDataSourceType:(FRDDataSourceType)sourceType
{
    id currentDataSource = nil;
    
    switch (sourceType) {
        case FRDDataSourceTypeSexualOrientation: {
            currentDataSource = [[FRDSexualOrientationDataSource alloc] init];
            break;
        }
        case FRDDataSourceTypeSmoker: {
            currentDataSource = [[FRDSmokerDataSource alloc] init];
            break;
        }
        default:
            break;
    }
    
    return currentDataSource;
}

+ (instancetype)dataSourceWithType:(FRDDataSourceType)sourceType
{
    return [[self alloc] initWithDataSourceType:sourceType];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = NSStringFromClass([FRDDropDownCell class]);
    FRDDropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[FRDDropDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.result) {
        [self.dropDownTableView hideDropDownList];
        self.result(self.dropDownTableView, self.currentDataSourceArray[indexPath.row]);
        self.result = nil;
    }
}

@end
