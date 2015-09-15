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
} FRDDataSourceType;

@interface FRDBaseDropDownDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *dropDownTableView;

+ (instancetype)dataSourceWithType:(FRDDataSourceType)sourceType;

@end
