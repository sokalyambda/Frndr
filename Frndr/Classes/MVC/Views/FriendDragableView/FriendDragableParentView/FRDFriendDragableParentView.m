//
//  FRDFriendDragableParentView.m
//  Frndr
//
//  Created by Eugenity on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDFriendDragableParentView.h"
#import "FRDFriendOverlayView.h"

#import "UIView+MakeFromXib.h"

@interface FRDFriendDragableParentView ()

@property (strong, nonatomic) FRDFriendOverlayView *overlayView;

@end

@implementation FRDFriendDragableParentView

#pragma mark - Accessors

- (void)setCurrentOverlayImageName:(NSString *)currentOverlayImageName
{
    self.overlayView.currentOverlayImageName = currentOverlayImageName;
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

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self addConstraints];
//}

- (void)commonInit
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.25f;
    self.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.layer.shadowRadius = 10.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.cornerRadius = 10.0;
    
    self.currentOverlayView = [FRDFriendOverlayView makeFromXib];
    [self.currentOverlayView setFrame:self.bounds];
    self.currentOverlayView.hidden = YES;
    [self addSubview:self.currentOverlayView];
    [self addConstraints];
}

- (void)addConstraints
{
    self.currentOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentOverlayView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0.0]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentOverlayView
//                                                          attribute:NSLayoutAttributeLeading
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self
//                                                          attribute:NSLayoutAttributeLeading
//                                                         multiplier:1.0
//                                                           constant:0.0]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentOverlayView
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0.0]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentOverlayView
//                                                          attribute:NSLayoutAttributeTrailing
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self
//                                                          attribute:NSLayoutAttributeTrailing
//                                                         multiplier:1.0
//                                                           constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentOverlayView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentOverlayView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
    
}

@end
