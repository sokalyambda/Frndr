//
//  FRDDropDownTableView.h
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class FRDBaseDropDownDataSource, FRDDropDownTableView;

typedef void(^DropDownCompletion)(FRDDropDownTableView *table, NSString *chosenValue);

@interface FRDDropDownTableView : UIView

@property (nonatomic) BOOL isExpanded;

- (void)dropDownTableBecomeActiveInView:(UIView *)presentedView
                         fromAnchorView:(UIView *)anchorView
                         withDataSource:(FRDBaseDropDownDataSource *)dataSource
                         withCompletion:(DropDownCompletion)completion;

- (void)hideDropDownList;

@end
