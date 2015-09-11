//
//  FRDCustomPageControl.h
//  Frndr
//
//  Created by Eugenity on 08.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"
#import <UIKit/UIKit.h>

#import <Availability.h>
#undef weak_delegate
#if __has_feature(objc_arc_weak)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif

extern const CGPathRef FXPageControlDotShapeCircle;
extern const CGPathRef FXPageControlDotShapeSquare;
extern const CGPathRef FXPageControlDotShapeTriangle;

@protocol FRDPageControlDelegate;

IB_DESIGNABLE @interface FRDCustomPageControl : UIControl

- (void)commonInit;
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;
- (void)updateCurrentPageDisplay;

@property (nonatomic, weak_delegate) IBOutlet id <FRDPageControlDelegate> delegate;

@property (nonatomic, assign) IBInspectable NSInteger currentPage;
@property (nonatomic, assign) IBInspectable NSInteger numberOfPages;
@property (nonatomic, assign) IBInspectable BOOL defersCurrentPageDisplay;
@property (nonatomic, assign) IBInspectable BOOL hidesForSinglePage;
@property (nonatomic, assign, getter = isWrapEnabled) IBInspectable BOOL wrapEnabled;
@property (nonatomic, assign, getter = isVertical) IBInspectable BOOL vertical;

@property (nonatomic, strong) IBInspectable UIImage *dotImage;
@property (nonatomic, assign) IBInspectable CGPathRef dotShape;
@property (nonatomic, assign) IBInspectable CGFloat dotSize;
@property (nonatomic, strong) IBInspectable UIColor *dotColor;
@property (nonatomic, strong) IBInspectable UIColor *dotShadowColor;
@property (nonatomic, assign) IBInspectable CGFloat dotShadowBlur;
@property (nonatomic, assign) IBInspectable CGSize dotShadowOffset;

@property (nonatomic, strong) IBInspectable UIImage *selectedDotImage;
@property (nonatomic, assign) IBInspectable CGPathRef selectedDotShape;
@property (nonatomic, assign) IBInspectable CGFloat selectedDotSize;
@property (nonatomic, strong) IBInspectable UIColor *selectedDotColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedDotShadowColor;
@property (nonatomic, assign) IBInspectable CGFloat selectedDotShadowBlur;
@property (nonatomic, assign) IBInspectable CGSize selectedDotShadowOffset;

@property (nonatomic, assign) IBInspectable CGFloat dotSpacing;

@end

@protocol FRDPageControlDelegate <NSObject>
@optional

- (UIImage *)pageControl:(FRDCustomPageControl *)pageControl imageForDotAtIndex:(NSInteger)index;
- (CGPathRef)pageControl:(FRDCustomPageControl *)pageControl shapeForDotAtIndex:(NSInteger)index;
- (UIColor *)pageControl:(FRDCustomPageControl *)pageControl colorForDotAtIndex:(NSInteger)index;

- (UIImage *)pageControl:(FRDCustomPageControl *)pageControl selectedImageForDotAtIndex:(NSInteger)index;
- (CGPathRef)pageControl:(FRDCustomPageControl *)pageControl selectedShapeForDotAtIndex:(NSInteger)index;
- (UIColor *)pageControl:(FRDCustomPageControl *)pageControl selectedColorForDotAtIndex:(NSInteger)index;

@end

#pragma GCC diagnostic pop
