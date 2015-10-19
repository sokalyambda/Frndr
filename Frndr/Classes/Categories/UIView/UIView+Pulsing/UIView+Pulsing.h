//
//  UIView+Pulsing.h
//  Frndr
//
//  Created by Eugenity on 01.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

@interface UIView (Pulsing)

- (void)pulsingWithWavesInView:(UIView *)viewForWaves repeating:(BOOL)repeating;

- (void)highlightWithScaling; //pulsing from greater to original

@end
