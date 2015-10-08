//
//  FRDExpandableToThresholdTextView.h
//  Frndr
//
//  Created by Pavlo on 10/8/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDVerticallyCenteredTextView.h"

@interface FRDExpandableToThresholdTextView : FRDVerticallyCenteredTextView

/**
 *  After overcoming this threshold TextView will be switched to standart scroll mode
 */
@property (nonatomic) NSInteger linesThreshold;

@end
