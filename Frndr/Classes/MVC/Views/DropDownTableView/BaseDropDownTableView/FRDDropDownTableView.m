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

static CGFloat kDefaultHeight = 200.f;
static CGFloat kDefaultConrerRadius = 5.f;
static CGFloat kDefaultAdditionalOffset = 5.f;
static CGFloat kDefaultSlideAnimationDuration = .5f;

@interface FRDDropDownTableView ()

@property (weak, nonatomic) IBOutlet UITableView *dropDownList;

@property (nonatomic) FRDBaseDropDownDataSource *dropDownDataSource;

@property (copy, nonatomic) PresentingCompletion presentingCompletion;

@property (weak, nonatomic) UIView *anchorView;
@property (weak, nonatomic) UIView *presentedView;

@property (nonatomic) CGFloat calculatedDropDownHeight;
@property (nonatomic) BOOL expandingNeeded;

@end

@implementation FRDDropDownTableView

#pragma mark - Accessors

- (void)setIsScrollEnabled:(BOOL)isScrollEnabled
{
    _isScrollEnabled = isScrollEnabled;
    self.dropDownList.scrollEnabled = isScrollEnabled;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setAreSeparatorsVisible:(BOOL)areSeparatorsVisible
{
    _areSeparatorsVisible = areSeparatorsVisible;
    self.dropDownList.separatorStyle = areSeparatorsVisible ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
}

// Value indicates the number of rows to which the height is adjusted dynamically
static NSInteger const kRowsNumberThreshold = 4;
- (CGFloat)calculatedDropDownHeight
{
    CGFloat calculatedHeight = 0;
    NSInteger numberOfRows = [self.dropDownList numberOfRowsInSection:0];
    UITableViewCell *firstCell = [self.dropDownList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGFloat rowHeight = CGRectGetHeight(firstCell.frame);
    
    if (numberOfRows <= kRowsNumberThreshold) {
        calculatedHeight = rowHeight * numberOfRows;
    } else {
        calculatedHeight = self.defaultHeight;
    }
    
    // If this view will exceed screen bounds then adjust its height to fit them
    CGRect expectedFrame = CGRectMake(CGRectGetMinX(self.frame),
                                      CGRectGetMinY(self.frame) + self.additionalOffset,
                                      CGRectGetWidth(self.frame),
                                      calculatedHeight);
    
    CGFloat verticalIntersection = 0;
    if ([self.presentedView isKindOfClass:[UIScrollView class]]) {
        verticalIntersection = CGRectGetMaxY(expectedFrame) - ((UIScrollView *)self.presentedView).contentSize.height;
    } else {
        verticalIntersection = CGRectGetMaxY(expectedFrame) - CGRectGetMaxY(self.presentedView.frame);
    }
    verticalIntersection = (verticalIntersection <= 0) ? 0 : verticalIntersection + self.additionalOffset;
    calculatedHeight -= verticalIntersection;
    
    return calculatedHeight;
}

- (void)setAnchorView:(UIView *)anchorView
{
    _anchorView = anchorView;
    
    if (_anchorView) {
        CGPoint relatedPoint = [_anchorView convertPoint:_anchorView.bounds.origin toView:self.presentedView];
        savedDropDownTableFrame = CGRectMake(relatedPoint.x, CGRectGetMaxY(_anchorView.bounds) + relatedPoint.y, CGRectGetWidth(_anchorView.frame), 0);
        self.frame = savedDropDownTableFrame;
    }
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)commonInit
{
    self.defaultHeight = kDefaultHeight;
    self.cornerRadius = kDefaultConrerRadius;
    self.additionalOffset = kDefaultAdditionalOffset;
    self.slideAnimationDuration = kDefaultSlideAnimationDuration;
    
    self.dropDownList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dropDownList.clipsToBounds = YES;
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
                  withShowingCompletion:(PresentingCompletion)presentingCompletion
                         withCompletion:(DropDownResult)result
{
    self.presentedView = presentedView;
    
    //If any action hasn't been called yet, but data source has been changed
    if (![dataSource isKindOfClass:[self.dropDownDataSource class]]) {
        self.anchorView = anchorView;
        self.expandingNeeded = NO;
    }
    
    self.presentingCompletion = presentingCompletion;
    //changing the table's data source and reload table's data
    self.dropDownDataSource = dataSource;
    self.dropDownDataSource.result = result;
    self.dropDownDataSource.dropDownTableView = self;
    self.dropDownList.dataSource = self.dropDownDataSource;
    self.dropDownList.delegate = self.dropDownDataSource;
    [self.dropDownList reloadData];
    
    if (!self.anchorView) {
        UIView *anchor = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.presentedView.frame), 0.f)];
        self.anchorView = anchor;
    }
    
    if (!self.expandingNeeded) {
        [self showDropDownList];
    } else {
        [self hideDropDownList];
    }
    
    self.expandingNeeded = !self.expandingNeeded;
}

- (void)showDropDownList
{
    [self.presentedView addSubview:self];
    [self layoutIfNeeded];
    
    self.isMoving = YES;
    
    [self rotateArrow];
    
    if (self.presentingCompletion) {
        self.isExpanded = YES;
        self.presentingCompletion(self);
    }
    [self rotateArrow];
    
    WEAK_SELF;
    [UIView animateWithDuration:self.slideAnimationDuration
                          delay:0.1f
         usingSpringWithDamping:.5f
          initialSpringVelocity:.5f
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            CGRect newFrame = weakSelf.frame;
                            newFrame.origin.y += weakSelf.additionalOffset;
                            newFrame.size.height = weakSelf.calculatedDropDownHeight;
                            weakSelf.frame = newFrame;
                            weakSelf.dropDownList.frame = newFrame;
                        }
                     completion:^(BOOL finished) {
                         
                         weakSelf.isMoving = NO;
                         
                     }];
}

- (void)hideDropDownList
{
    [self layoutIfNeeded];
    
    self.isMoving = YES;
    
    if (self.presentingCompletion) {
        self.isExpanded = NO;
        self.presentingCompletion(self);
    }

    [self rotateArrow];
    
    WEAK_SELF;
    [UIView animateWithDuration:self.slideAnimationDuration
                          delay:0.1f
         usingSpringWithDamping:1.f
          initialSpringVelocity:1.f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            weakSelf.frame = savedDropDownTableFrame;
                            [weakSelf layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                         weakSelf.anchorView = nil;
                         weakSelf.dropDownDataSource = nil;
                         [weakSelf removeFromSuperview];
                         
                         weakSelf.isMoving = NO;

                     }];
}

/**
 *  Rotate current arrow
 */
- (void)rotateArrow
{
    if (!self.rotatingArrow) {
        return;
    }
    
    [UIView animateWithDuration:.2f animations:^{
        self.rotatingArrow.transform = self.isExpanded ? CGAffineTransformRotate(self.rotatingArrow.transform, M_PI) : CGAffineTransformMakeRotation(0);
    }];
}

@end
