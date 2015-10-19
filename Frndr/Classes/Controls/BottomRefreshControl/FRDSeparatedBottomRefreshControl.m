//
//  FRDBottomRefreshControlMediator.m
//  Frndr
//
//  Created by Pavlo on 10/12/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDSeparatedBottomRefreshControl.h"

@interface FRDSeparatedBottomRefreshControl ()

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (readonly, nonatomic) UITableViewCell *lastVisibleCell;
@property (strong, nonatomic) UIView *refreshBackgroundView;

@property (nonatomic) CGFloat pullHeightTreshold;
@property (nonatomic) CGFloat defaultIndicatorHeight;
@property (nonatomic) CGFloat savedAnchorHeight;

@property (nonatomic) BOOL isDragging;

@end

@implementation FRDSeparatedBottomRefreshControl

#pragma mark - Accessors

- (CGFloat)pullHeightTreshold
{
    return 100.f;
}

- (UITableViewCell *)lastVisibleCell
{
    return self.tableView.visibleCells.lastObject;
}

#pragma mark - Lifecycle

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self = [super init]) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.color = [UIColor blackColor];
        [_activityIndicatorView startAnimating];
        _defaultIndicatorHeight = CGRectGetHeight(_activityIndicatorView.frame);
        
        _tableView = tableView;
        [_tableView.tableFooterView addSubview:_activityIndicatorView];
        _tableView.tableFooterView.clipsToBounds = YES;
        _tableView.tableFooterView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_tableView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
        
        [self adjustFramesWithOffsetY:0.f];
    }
    return self;
}

-(void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:self forKeyPath:@"pan.state"];
}

#pragma mark - Actions

/**
 *  Redraw indicator and background depending on scroll offset
 */
- (void)adjustFramesWithOffsetY:(CGFloat)offsetY
{
    self.tableView.tableFooterView.frame = CGRectMake(CGRectGetMinX(self.tableView.tableFooterView.frame),
                                                      self.tableView.contentSize.height,
                                                      CGRectGetWidth(self.tableView.frame),
                                                      offsetY);
    
    CGFloat activityIndicatorScale = MIN(self.defaultIndicatorHeight, offsetY) / self.defaultIndicatorHeight;
    
    self.activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.tableView.tableFooterView.bounds),
                                                    CGRectGetMidY(self.tableView.tableFooterView.bounds));
    
    self.activityIndicatorView.transform = CGAffineTransformMakeScale(activityIndicatorScale, activityIndicatorScale);
}

/**
 *  Begin refreshing programmatically
 */
- (void)beginRefreshing
{
    _refreshing = YES;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/**
 *  Call when refreshing actions are done
 */
- (void)endRefreshing
{
    NSLog(@"Refreshing ended");
    self.tableView.panGestureRecognizer.enabled = NO;
    [self setDefaultInsetsAnimated];
    _refreshing = NO;
}

- (void)setDefaultInsetsAnimated
{
    WEAK_SELF;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         weakSelf.tableView.contentInset = UIEdgeInsetsZero;
                         [weakSelf adjustFramesWithOffsetY:0.01];
                     } completion:^(BOOL finished) {
                         [weakSelf adjustFramesWithOffsetY:0.f];
                         weakSelf.tableView.panGestureRecognizer.enabled = YES;
                     }];
}

#pragma mark - Observers

/**
 *  To keep UITableViewDelegate free for other classes to use we're catching table view scroll events by observing its content offset property
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGPoint contentOffset = ((NSValue *)change[NSKeyValueChangeNewKey]).CGPointValue;
    CGFloat offsetY;
    
    if (self.tableView.contentSize.height < [UIScreen mainScreen].bounds.size.height - self.additionalVerticalInset) {
        offsetY = contentOffset.y;
    } else {
        offsetY = contentOffset.y - self.tableView.contentSize.height + [UIScreen mainScreen].bounds.size.height - self.additionalVerticalInset;
    }
    
    offsetY = MAX(0, offsetY);
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.isDragging || self.refreshing) {
            if (offsetY > self.pullHeightTreshold && !self.refreshing) {
                [self beginRefreshing];
                self.tableView.contentInset = UIEdgeInsetsMake(-self.pullHeightTreshold, 0, self.pullHeightTreshold, 0);
            }
            
            if (offsetY < self.pullHeightTreshold && !self.refreshing) {
                self.tableView.contentInset = UIEdgeInsetsMake(-offsetY, 0, offsetY, 0);
            }
            
            [self adjustFramesWithOffsetY:offsetY];
        }
    } else if ([keyPath isEqualToString:@"pan.state"]) {
        switch (self.tableView.panGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan: {
                self.isDragging = YES;
                break;
            }
 
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed: {
                self.isDragging = NO;
                if (offsetY < self.pullHeightTreshold && !self.refreshing) {
                    [self setDefaultInsetsAnimated];
                } 
            }
                
            default:
                break;
        }
    }
}

@end
