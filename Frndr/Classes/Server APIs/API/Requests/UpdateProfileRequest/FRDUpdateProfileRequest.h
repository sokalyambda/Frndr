//
//  FRDUpdateProfileRequest.h
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNetworkRequest.h"

@interface FRDUpdateProfileRequest : FRDNetworkRequest

@property (strong, nonatomic) FRDCurrentUserProfile *confirmedProfile;

- (instancetype)initWithUpdatedProfile:(FRDCurrentUserProfile *)updatedProfile;

@end
