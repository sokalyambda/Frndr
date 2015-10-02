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

#import "FRDDropDownTableView.h"

@interface FRDBaseDropDownDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) FRDDropDownTableView *dropDownTableView;
@property (copy, nonatomic) DropDownResult result;

+ (instancetype)dataSourceWithType:(FRDDataSourceType)sourceType;

@end
