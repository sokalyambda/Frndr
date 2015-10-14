//
//  FRDNoMatchesView.m
//  Frndr
//
//  Created by Eugenity on 14.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNoMatchesView.h"

@implementation FRDNoMatchesView

#pragma mark - Actions

- (IBAction)discoverNewPeopleClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(noMatchesViewShouldShowSearchNearestUsersController:)]) {
        [self.delegate noMatchesViewShouldShowSearchNearestUsersController:self];
    }
}

@end
