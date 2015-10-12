//
//  FRDBottomRefreshControlMediator.m
//  Frndr
//
//  Created by Pavlo on 10/12/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDDSeparatedBottomRefreshControl.h"

@interface FRDDSeparatedBottomRefreshControl () <UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (readonly, nonatomic) UITableViewCell *lastVisibleCell;

@property (nonatomic) CGFloat pullHeightTreshold;
@property (nonatomic) CGFloat defaultIndicatorHeight;

@end

@implementation FRDDSeparatedBottomRefreshControl

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
        
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_tableView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
        
        [self adjustFrames];
    }
    return self;
}

-(void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:self forKeyPath:@"pan.state"];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustFrames];
    NSLog(@"Layout subviews");
}

#pragma mark - Actions

/**
 *  Redraw indicator and background depending on scroll offset
 */
- (void)adjustFrames
{
    CGFloat offsetY = self.tableView.contentOffset.y - self.tableView.contentSize.height + CGRectGetMaxY(self.lastVisibleCell.frame);
    offsetY = MAX(0, offsetY);
    
    self.tableView.tableFooterView.frame = CGRectMake(CGRectGetMinX(self.tableView.tableFooterView.frame),
                                                      CGRectGetMaxY(self.lastVisibleCell.frame),
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
    [self setDefaultInsetsAnimated];
    _refreshing = NO;
}

- (void)setDefaultInsetsAnimated
{
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.tableView.contentInset = UIEdgeInsetsZero;
                     } completion:nil];
}

#pragma mark - Observers

/**
 *  To keep UITableViewDelegate free for other classes to use we're catching table view scroll events by observing its content offset property
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = ((NSValue *)change[NSKeyValueChangeNewKey]).CGPointValue;
        CGFloat offsetY = contentOffset.y - self.tableView.contentSize.height + CGRectGetMaxY(self.lastVisibleCell.frame);
        offsetY = MAX(0, offsetY);
        
        if (offsetY <= self.pullHeightTreshold && !self.refreshing) {
            self.tableView.contentInset = UIEdgeInsetsMake(-offsetY, 0, offsetY, 0);
        }
        
        if (offsetY > self.pullHeightTreshold && !self.refreshing) {
            [self beginRefreshing];
            self.tableView.contentInset = UIEdgeInsetsMake(-self.pullHeightTreshold, 0, self.pullHeightTreshold, 0);
        }
        
        [self adjustFrames];
    } else if ([keyPath isEqualToString:@"pan.state"]) {
        if ((self.tableView.panGestureRecognizer.state == UIGestureRecognizerStateEnded ||
             self.tableView.panGestureRecognizer.state == UIGestureRecognizerStateCancelled) &&
            self.tableView.contentInset.bottom < self.pullHeightTreshold) {
            [self setDefaultInsetsAnimated];
        }
    }
}

@end
