//
//  FRDPhotoGalleryCollectionViewLayout.m
//  Frndr
//
//  Created by Pavlo on 9/10/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDPhotoGalleryCollectionViewLayout.h"

static CGFloat const fullSpace = 2.f;
static CGFloat const halfSpace = fullSpace / 2;
static CGFloat const quarterSpace = halfSpace / 2;

@interface FRDPhotoGalleryCollectionViewLayout ()

@property (assign, readwrite, nonatomic) CGSize mainPhotoSize;
@property (assign, readwrite, nonatomic) CGSize secondaryPhotoSize;

@end

@implementation FRDPhotoGalleryCollectionViewLayout

- (instancetype)init
{
    if (self = [super init]) {
        CGFloat bigSide = self.collectionView.frame.size.width * (2.0 / 3.0);
        _mainPhotoSize = CGSizeMake(bigSide, bigSide);
        
        CGFloat smallSide = self.collectionView.frame.size.width * (1.0 / 3.0);
        _secondaryPhotoSize = CGSizeMake(smallSide, smallSide);
    }
    return self;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self modifyLayoutAttributes:attributes];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesInRect = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *cellAttributes in attributesInRect) {
        [self modifyLayoutAttributes:cellAttributes];
    }
    return attributesInRect;
}

- (void)modifyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    static NSInteger row = 0;
    
    NSInteger column = attributes.indexPath.item % 3;
    if (column == 2) {
        row++;
    }
    
    CGFloat bigSize = self.collectionView.frame.size.width * (2.0 / 3.0);
    CGFloat smallSize = self.collectionView.frame.size.width - bigSize;
    
    if (attributes.indexPath.item == 0) {
        attributes.frame = CGRectMake(0, 0, bigSize - halfSpace, bigSize);
    }
    else if (attributes.indexPath.item == 1) {
        attributes.frame = CGRectMake(bigSize + halfSpace,
                                      0,
                                      smallSize - halfSpace,
                                      smallSize - halfSpace);
    }
    else if (attributes.indexPath.item == 2) {
        attributes.frame = CGRectMake(bigSize + halfSpace,
                                      smallSize + halfSpace,
                                      smallSize - halfSpace,
                                      smallSize - halfSpace);
    }
    else {
        CGFloat xOffset = (column == 1) ? halfSpace : quarterSpace;
        CGFloat widthOffset = (column == 1) ? fullSpace : halfSpace;
        
        attributes.frame = CGRectMake((smallSize + xOffset) * column,
                                      (bigSize + fullSpace) * row,
                                      smallSize - widthOffset,
                                      smallSize - halfSpace);
    }
}

@end
