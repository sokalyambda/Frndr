//
//  FRDDropDownTableView.h
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class FRDBaseDropDownDataSource, FRDDropDownTableView;

typedef void(^DropDownResult)(FRDDropDownTableView *table, id chosenValue);
typedef void(^PresentingCompletion)(FRDDropDownTableView *table);

@interface FRDDropDownTableView : UIView


@property (strong, nonatomic) UIImageView *arrowImageView;
@property (nonatomic) BOOL isExpanded;

- (void)dropDownTableBecomeActiveInView:(UIView *)presentedView
                         fromAnchorView:(UIView *)anchorView
                         withDataSource:(FRDBaseDropDownDataSource *)dataSource
                  withShowingCompletion:(PresentingCompletion)presentingCompletion
                         withCompletion:(DropDownResult)result;

- (void)hideDropDownList;

@end
