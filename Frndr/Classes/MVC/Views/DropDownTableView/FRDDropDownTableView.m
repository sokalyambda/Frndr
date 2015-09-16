//
//  FRDDropDownTableView.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDDropDownTableView.h"

#import "FRDBaseDropDownDataSource.h"

#import "CAAnimation+CompetionBlock.h"

static NSUInteger const kDropDownHeight = 200.f;
static CGFloat const kSlidingTime = .5f;

@interface FRDDropDownTableView ()

@property (weak, nonatomic) IBOutlet UITableView *dropDownList;

@property (nonatomic) FRDBaseDropDownDataSource *dropDownDataSource;

@property (weak, nonatomic) UIView *anchorView;
@property (weak, nonatomic) UIView *presentedView;

@end

@implementation FRDDropDownTableView {
    CGRect savedDropDownTableFrame;
}

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    self.dropDownList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Accessors

- (void)setAnchorView:(UIView *)anchorView
{
    _anchorView = anchorView;
    
    CGPoint relatedPoint = [_anchorView convertPoint:_anchorView.bounds.origin toView:self.presentedView];
    
    savedDropDownTableFrame = CGRectMake(relatedPoint.x, CGRectGetMaxY(_anchorView.bounds) + relatedPoint.y, CGRectGetWidth(_anchorView.frame), 0);
    
    self.frame = savedDropDownTableFrame;
}

#pragma mark - Actions

/**
 * Show or hide drop down table from common anchor view in some parent view.
 * @author EugeneS.
 *
 * @param presentedView The view that will be the parent view of drop down list.
 * @param anchorView The view that defines the origin and, currently, width of drop down list.
 * @param dataSource This is the current data source for drop down table view, it will be changed relative the needed filters (..or something else). It will be written to private property to avoid it's deallocation before we done with it.
 * @param completion The block which will be called when the user taps the action button.
 */

- (void)dropDownTableBecomeActiveInView:(UIView *)presentedView
                         fromAnchorView:(UIView *)anchorView
                         withDataSource:(FRDBaseDropDownDataSource *)dataSource
                         withCompletion:(DropDownCompletion)completion
{
    self.presentedView = presentedView;
    
    //If any action hasn't been called yet, but data source has been changed
    if (![dataSource isKindOfClass:[self.dropDownDataSource class]]) {
        self.anchorView = anchorView;
        self.isExpanded = NO;
    }
    
    //changing the table's data source and reload table's data
    self.dropDownDataSource = dataSource;
    self.dropDownDataSource.completion = completion;
    self.dropDownDataSource.dropDownTableView = self;
    self.dropDownList.dataSource = self.dropDownDataSource;
    self.dropDownList.delegate = self.dropDownDataSource;
    [self.dropDownList reloadData];
    
    if (!self.isExpanded) {
        [self showDropDownList];
    } else {
        [self hideDropDownList];
    }
    
    self.isExpanded = !self.isExpanded;
}

- (void)showDropDownList
{
    WEAK_SELF;
    [UIView animateWithDuration:kSlidingTime animations:^{
        
        [weakSelf.dropDownList setHidden:YES];
        
        [weakSelf.presentedView addSubview:self];
        CGRect newFrame = self.frame;
        newFrame.size.height = kDropDownHeight;
        weakSelf.frame = newFrame;
    } completion:^(BOOL complete){
        [weakSelf.dropDownList setHidden:NO];
    }];
}

- (void)hideDropDownList
{
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
//    animation.values = @[
//                         [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))],
//                         [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2)],
//                         [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/3)],
//                         [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/4)],
//                         [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/5)],
//                         [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/6)]];
//    animation.duration = .5f;
    WEAK_SELF;
//
//    animation.end = ^(BOOL end) {
//        if ([weakSelf.anchorView isKindOfClass:[UITextField class]]) {
//            [(UITextField *)weakSelf
//             .anchorView resignFirstResponder];
//        }
//        weakSelf.anchorView = nil;
//        weakSelf.dropDownDataSource = nil;
//        [weakSelf removeFromSuperview];
//    };
//    
//    [self.layer addAnimation:animation forKey:@"bounds"];
    [UIView animateWithDuration:kSlidingTime animations:^{
        weakSelf.frame = savedDropDownTableFrame;
    } completion:^(BOOL finished) {
        if ([weakSelf.anchorView isKindOfClass:[UITextField class]]) {
            [(UITextField *)weakSelf
             .anchorView resignFirstResponder];
        }
        weakSelf.anchorView = nil;
        weakSelf.dropDownDataSource = nil;
        [weakSelf removeFromSuperview];
    }];
}

@end
