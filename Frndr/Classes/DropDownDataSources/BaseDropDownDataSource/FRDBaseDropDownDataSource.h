//
//  FRDBaseDropDownDataSource.h
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

typedef enum : NSUInteger {
    FRDDataSourceTypeSmoker,
    FRDDataSourceTypeSexualOrientation,
    FRDDataSourceTypeChatOptions
} FRDDataSourceType;

#import "FRDDropDownTableView.h"

#import "FRDBaseViewController.h"

@interface FRDBaseDropDownDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) FRDDropDownTableView *dropDownTableView;
@property (copy, nonatomic) DropDownResult result;

@property (nonatomic) FRDSourceType sourceType;//can be important (e.g. smoker)

+ (instancetype)dataSourceWithType:(FRDDataSourceType)sourceType;

@end
