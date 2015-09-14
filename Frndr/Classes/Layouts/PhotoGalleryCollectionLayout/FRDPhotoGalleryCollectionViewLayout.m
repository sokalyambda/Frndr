//
//  FRDPhotoGalleryCollectionViewLayout.m
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryCollectionViewLayout.h"

static CGFloat const kFullSpace = 2.f;
static CGFloat const kHalfSpace = kFullSpace / 2;
static CGFloat const kQuarterSpace = kHalfSpace / 2;

@interface FRDPhotoGalleryCollectionViewLayout ()

@property (assign, readwrite, nonatomic) CGFloat oneThirdOfScreenWidth;
@property (assign, readwrite, nonatomic) CGFloat twoThirdsOfScreenWidth;

@property (assign, readwrite, nonatomic) CGSize mainPhotoSize;
@property (assign, readwrite, nonatomic) CGSize secondaryPhotoSize;
@property (assign, readwrite, nonatomic) CGSize contentSize;

@property (strong, nonatomic) NSMutableArray *attributes;

@property (strong, nonatomic) NSMutableDictionary *layoutAttributes;

@end


@implementation FRDPhotoGalleryCollectionViewLayout


- (void)prepareLayout
{
    [super prepareLayout];
    
    self.oneThirdOfScreenWidth = CGRectGetWidth(self.collectionView.frame) * (1.0 / 3.0);
    self.twoThirdsOfScreenWidth = CGRectGetWidth(self.collectionView.frame) * (2.0 / 3.0);
    
    self.mainPhotoSize = CGSizeMake(self.twoThirdsOfScreenWidth, self.twoThirdsOfScreenWidth);
    self.secondaryPhotoSize = CGSizeMake(self.oneThirdOfScreenWidth, self.oneThirdOfScreenWidth);
    
    NSInteger numberOfElements = [self.collectionView numberOfItemsInSection:0];
    
    self.attributes = [NSMutableArray arrayWithCapacity:numberOfElements];
    for (int i = 0; i < numberOfElements; ++i) {
        UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cellAttributes.frame = [self frameForElementAtIndexPath:cellAttributes.indexPath];
        
        [self.attributes addObject:cellAttributes];
        
        NSLog(@"{ %f : %f }", cellAttributes.frame.origin.x, cellAttributes.frame.origin.y);
    }
    
    UICollectionViewLayoutAttributes *lastCellAttributes = self.attributes.lastObject;
    self.contentSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds),
                                  CGRectGetMaxY(lastCellAttributes.frame));
    
    NSLog(@"Content size: WIDTH = %f, HEIGHT = %f", self.contentSize.width, self.contentSize.height);
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"New Rect");
    NSLog(@" ");
    // NSLog(@"{ %f : %f } { %f : %f }", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    NSMutableArray *attributesInRect = [NSMutableArray arrayWithCapacity:20];
    
    for (UICollectionViewLayoutAttributes *cellAttributes in self.attributes) {
        if (CGRectIntersectsRect(rect, cellAttributes.frame)) {
            [attributesInRect addObject:cellAttributes];
            
            
            NSLog(@"{ %.1f : %.1f }", cellAttributes.frame.origin.x, cellAttributes.frame.origin.y);
        }
    }
    
    return attributesInRect;
}

- (CGRect)frameForElementAtIndexPath:(NSIndexPath *)indexPath
{
    static NSInteger row = 0;
    
    NSInteger column = indexPath.item % 3;
    if (column == 0) {
        row++;
    }
    
    // Offsets for items that are not Main or Side
    CGFloat xOffset;
    CGFloat widthOffset;
    
    GalleryLayoutItemType type = indexPath.item;
    switch (type) {
        case Main:
            return CGRectMake(0,
                              0,
                              self.mainPhotoSize.width - kHalfSpace,
                              self.mainPhotoSize.height);
            break;
            
        case FirstSide:
            return CGRectMake(self.mainPhotoSize.width + kHalfSpace,
                              0,
                              self.secondaryPhotoSize.width - kHalfSpace,
                              self.secondaryPhotoSize.height - kHalfSpace);
            break;
            
        case SecondSide:
            return CGRectMake(self.mainPhotoSize.width + kHalfSpace,
                              self.secondaryPhotoSize.height + kHalfSpace,
                              self.secondaryPhotoSize.width - kHalfSpace,
                              self.secondaryPhotoSize.height - kHalfSpace);
            break;
            
        default:
            xOffset = (column == 1) ? kHalfSpace : kQuarterSpace;
            widthOffset = (column == 1) ? kFullSpace : kHalfSpace;
            
            return CGRectMake((self.secondaryPhotoSize.width + xOffset) * column,
                              (self.secondaryPhotoSize.height + kHalfSpace) * row,
                              self.secondaryPhotoSize.width - widthOffset,
                              self.secondaryPhotoSize.height - kHalfSpace);
            break;
    }
}

@end
