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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.options.count - 1) {
        cell.backgroundColor = [UIColor clearColor];
    } else {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                     CGRectGetWidth(cell.contentView.frame),
                                                                     1.0 / [UIScreen mainScreen].scale)];
        separator.backgroundColor = (indexPath.row == 0) ? UIColorFromRGBWithAlpha(0x0, 0.3) : UIColorFromRGBWithAlpha(0x0, 0.15);
        [cell.contentView addSubview:separator];
        
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    FRDChatOption *option = self.options[indexPath.row];
    //cell.textLabel.text = option.optionString;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.row != self.options.count - 1) {
        cell.textLabel.textColor = UIColorFromRGB(0x58406C);
    } else {
        cell.textLabel.textColor = UIColorFromRGB(0xFFFFFF);
    }
}

@end
