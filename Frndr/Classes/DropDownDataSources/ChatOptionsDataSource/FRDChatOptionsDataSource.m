//
//  FRDChatOptionsDataSource.m
//  Frndr
//
//  Created by Pavlo on 10/6/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDChatOptionsDataSource.h"

#import "FRDDropDownCell.h"

#import "FRDChatOption.h"

@interface FRDChatOptionsDataSource ()

@property (strong, nonatomic) NSArray *options;

@end

@implementation FRDChatOptionsDataSource

#pragma mark - Accessors

- (NSArray *)options
{
    if (!_options) {
        _options = @[[FRDChatOption chatOptionWithOptionType:FRDChatOptionsTypeViewProfile],
                     [FRDChatOption chatOptionWithOptionType:FRDChatOptionsTypeClearChat],
                     [FRDChatOption chatOptionWithOptionType:FRDChatOptionsTypeBlockUser],
                     [FRDChatOption chatOptionWithOptionType:FRDChatOptionsTypeCancel]];
    }
    return _options;
}

- (NSArray *)currentDataSourceArray
{
    return self.options;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    FRDChatOption *option = self.options[indexPath.row];
    
    cell.textLabel.text = option.optionString;
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger lastCellIndex = self.options.count - 1;
    cell.textLabel.textColor = indexPath.row == lastCellIndex ? [UIColor whiteColor] : UIColorFromRGB(0x58406C);
    cell.backgroundColor = indexPath.row == lastCellIndex ? [UIColor clearColor] : [UIColor whiteColor];
}

@end
