//
//  FRDNearestUser.m
//  Frndr
//
//  Created by Eugenity on 23.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDNearestUser.h"

#import "FRDRelationshipItem.h"

static NSString *const kRelStatus = @"relStatus";

@implementation FRDNearestUser

#pragma mark - FRDMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super initWithServerResponse:response];
    
    if (self) {
        
        _relationshipStatus = [FRDRelationshipItem relationshipItemWithTitle:response[kRelStatus] andActiveImage:@"" andNotActiveImage:@""] ;
        
    }
    return self;
}

@end
