//
//  FRDDislikeUserByIdRequest.m
//  Frndr
//
//  Created by Eugenity on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDDislikeUserByIdRequest.h"

static NSString *const kRequestAction = @"users/dislike";

@implementation FRDDislikeUserByIdRequest

#pragma mark - Accessors

- (NSString *)requestAction
{
    return [NSString stringWithFormat:@"%@/%@", kRequestAction, self.currentUserId];
}

@end
