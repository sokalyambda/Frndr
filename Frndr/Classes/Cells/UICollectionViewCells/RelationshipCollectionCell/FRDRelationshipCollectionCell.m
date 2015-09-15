//
//  FRDRelationshipCollectionCell.m
//  Frndr
//
//  Created by Eugenity on 15.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "FRDRelationshipCollectionCell.h"

#import "FRDRelationshipItem.h"

@interface FRDRelationshipCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *relationshipImageView;
@property (weak, nonatomic) IBOutlet UILabel *relationshipTitleLabel;

@end

@implementation FRDRelationshipCollectionCell

- (void)configureCellWithRelationshipItem:(FRDRelationshipItem *)item
{
    if (item.isSelected) {
        self.relationshipImageView.image = item.relationshipImage;
    } else {
        self.relationshipImageView.image = item.relationshipNotActiveImage;
    }
    self.relationshipTitleLabel.text = item.relationshipTitle;
}

@end