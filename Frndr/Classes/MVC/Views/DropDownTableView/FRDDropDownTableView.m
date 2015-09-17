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

static CGFloat const kDropDownHeight = 200.f;

@interface FRDDropDownTableView ()

@property (weak, nonatomic) IBOutlet UITableView *dropDownList;

@property (nonatomic) FRDBaseDropDownDataSource *dropDownDataSource;

@property (weak, nonatomic) UIView *anchorView;
@property (weak, nonatomic) UIView *presentedView;

@property (nonatomic) CGFloat calculatedDropDownHeight;

@end

@implementation FRDDropDownTableView {
    CGRect savedDropDownTableFrame;
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
    self.layer.cornerRadius = 5.0;
    self.dropDownList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Accessors

- (CGFloat)calculatedDropDownHeight
{
    CGFloat actualHeight = kDropDownHeight;

    NSLog(@"presented view frame %@", NSStringFromCGRect(self.presentedView.frame));
    NSLog(@"anchor view frame %@", NSStringFromCGRect(self.anchorView.frame));
    
    if (CGRectContainsPoint(self.presentedView.frame, CGPointMake(CGRectGetMinX(self.anchorView.frame), CGRectGetMaxY(self.anchorView.frame) + actualHeight))) {
        NSLog(@"OK");
    } else {
        NSLog(@"HOOJOK");
    }
    return actualHeight;
}

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

static CGFloat const kAdditionalOffset = 5.f;
static CGFloat const kSlidingTime = .5f;
- (void)showDropDownList
{
    WEAK_SELF;
    [UIView animateWithDuration:kSlidingTime
                          delay:0.1f
         usingSpringWithDamping:.5f
          initialSpringVelocity:.5f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [weakSelf.presentedView addSubview:self];
                            CGRect newFrame = self.frame;
                            newFrame.origin.y += kAdditionalOffset;
                            newFrame.size.height = self.calculatedDropDownHeight;
                            weakSelf.dropDownList.frame = newFrame;
                            weakSelf.frame = newFrame;
                        }
                     completion:nil];
}

- (void)hideDropDownList
{
    WEAK_SELF;
    [UIView animateWithDuration:kSlidingTime
                          delay:0.1f
         usingSpringWithDamping:1.f
          initialSpringVelocity:1.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            weakSelf.frame = savedDropDownTableFrame;
                        }
                     completion:^(BOOL finished) {
                         if ([weakSelf.anchorView isKindOfClass:[UITextField class]]) {
                             [(UITextField *)weakSelf.anchorView resignFirstResponder];
                         }
                         weakSelf.anchorView = nil;
                         weakSelf.dropDownDataSource = nil;
                         [weakSelf removeFromSuperview];
                     }];
}

@end
