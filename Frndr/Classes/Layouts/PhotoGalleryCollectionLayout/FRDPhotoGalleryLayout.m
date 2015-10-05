//
//  FRDPhotoGalleryCollectionViewLayout.m
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryLayout.h"

static CGFloat const kFullSpace = 4.f;
static CGFloat const kHalfSpace = kFullSpace / 2;
static CGFloat const kQuarterSpace = kHalfSpace / 2;

@interface FRDPhotoGalleryLayout ()

@property (nonatomic) NSInteger row;

@property (nonatomic) CGFloat oneThirdOfScreenWidth;
@property (nonatomic) CGFloat twoThirdsOfScreenWidth;

@property (nonatomic) CGSize mainPhotoSize;
@property (nonatomic) CGSize secondaryPhotoSize;
@property (nonatomic) CGSize contentSize;

@property (nonatomic) NSMutableArray *attributes;

@end


@implementation FRDPhotoGalleryLayout

#pragma mark - Accessors

- (CGFloat)oneThirdOfScreenWidth
{
    return CGRectGetWidth(self.collectionView.frame) * (1.0 / 3.0);
}

- (CGFloat)twoThirdsOfScreenWidth
{
    return CGRectGetWidth(self.collectionView.frame) * (2.0 / 3.0);
}

- (CGSize)mainPhotoSize
{
    return CGSizeMake(self.twoThirdsOfScreenWidth, self.twoThirdsOfScreenWidth);
}

- (CGSize)secondaryPhotoSize
{
    return CGSizeMake(self.oneThirdOfScreenWidth, self.oneThirdOfScreenWidth);
}

- (void)prepareLayout
{
    [super prepareLayout];

    self.row = 0;
    
    NSInteger numberOfElements = [self.collectionView numberOfItemsInSection:0];
    self.attributes = [NSMutableArray arrayWithCapacity:numberOfElements];
    
    for (int i = 0; i < numberOfElements; ++i) {
        UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cellAttributes.frame = [self frameForElementAtIndexPath:cellAttributes.indexPath];
        
        [self.attributes addObject:cellAttributes];
    }
    
    UICollectionViewLayoutAttributes *lastCellAttributes = self.attributes.lastObject;
    self.contentSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds),
                                  CGRectGetMaxY(lastCellAttributes.frame));
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesInRect = [NSMutableArray arrayWithCapacity:20];
    
    for (UICollectionViewLayoutAttributes *cellAttributes in self.attributes) {
        if (CGRectIntersectsRect(rect, cellAttributes.frame)) {
            [attributesInRect addObject:cellAttributes];
        }
    }
    
    return attributesInRect;
}

- (CGRect)frameForElementAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger column = indexPath.item % 3;
    if (column == 0) {
        self.row++;
    }

    // Offsets for items that are not Main or Side
    CGFloat xOffset;
    CGFloat widthOffset;
    
    FRDGalleryLayoutItemType type = indexPath.item;
    switch (type) {
        case FRDGalleryItemTypeMain:
            return CGRectMake(0,
                              0,
                              self.mainPhotoSize.width - kHalfSpace,
                              self.mainPhotoSize.height);
            
        case FRDGalleryItemTypeFirstSide:
            return CGRectMake(self.mainPhotoSize.width + kHalfSpace,
                              0,
                              self.secondaryPhotoSize.width - kHalfSpace,
                              self.secondaryPhotoSize.height - kHalfSpace);
            
        case FRDGalleryItemTypeSecondSide:
            return CGRectMake(self.mainPhotoSize.width + kHalfSpace,
                              self.secondaryPhotoSize.height + kHalfSpace,
                              self.secondaryPhotoSize.width - kHalfSpace,
                              self.secondaryPhotoSize.height - kHalfSpace);
            
        default:
            xOffset = (column == 1) ? kHalfSpace : kQuarterSpace;
            widthOffset = (column == 1) ? kFullSpace : kHalfSpace;
            
            return CGRectMake((self.secondaryPhotoSize.width + xOffset) * column,
                              (self.secondaryPhotoSize.height + kHalfSpace) * self.row,
                              self.secondaryPhotoSize.width - widthOffset,
                              self.secondaryPhotoSize.height - kHalfSpace);
    }
}

@end
