//
//  FRDGetFriendsListRequest.h
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDGetFriendsListRequest : FRDNetworkRequest

@property (nonatomic) NSArray *friendsList;

- (instancetype)initWithPage:(NSInteger)page;

@end
