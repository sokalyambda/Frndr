//
//  FRDFindNearestUsersRequest.h
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDFindNearestUsersRequest : FRDNetworkRequest

@property (strong, nonatomic) NSArray *nearestUsers;

- (instancetype)initWithPage:(NSInteger)page;

@end
