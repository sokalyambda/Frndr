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

@interface FRDDropDownTableView : UIView {
    @protected
    __weak UIView *_presentedView;
    __weak UIView *_anchorView;
    __weak UITableView *_dropDownList;
    PresentingCompletion _presentingCompletion;
    CGRect savedDropDownTableFrame;
    FRDBaseDropDownDataSource *_dropDownDataSource;
}

//Moving&Expanding
@property (nonatomic) BOOL isMoving;
@property (nonatomic) BOOL isExpanded;

//Additional settings
@property (nonatomic) BOOL isScrollEnabled;
@property (nonatomic) BOOL areSeparatorsVisible;

@property (nonatomic) CGFloat defaultHeight;
@property (nonatomic) CGFloat additionalOffset;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat slideAnimationDuration;

@property (strong, nonatomic) UIImageView *rotatingArrow;

- (CGFloat)calculatedDropDownHeight;

- (void)dropDownTableBecomeActiveInView:(UIView *)presentedView
                         fromAnchorView:(UIView *)anchorView
                         withDataSource:(FRDBaseDropDownDataSource *)dataSource
                  withShowingCompletion:(PresentingCompletion)presentingCompletion
                         withCompletion:(DropDownResult)result;

- (void)hideDropDownList;

@end
