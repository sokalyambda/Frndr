//
//  FRDRelationshipCollectionCell.h
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class FRDRelationshipItem, FRDRoundedView;

@interface FRDRelationshipCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet FRDRoundedView *roundedBackgroundView;

- (void)configureCellWithRelationshipItem:(FRDRelationshipItem *)item;
- (void)updateCellWithRelationshipItem:(FRDRelationshipItem *)item;

@end
