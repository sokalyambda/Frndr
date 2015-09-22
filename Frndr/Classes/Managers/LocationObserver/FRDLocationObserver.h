//
//  FRDLocationObserver.h
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface FRDLocationObserver : NSObject

+ (FRDLocationObserver *)sharedObserver;

@property (nonatomic, getter=isAuthorized) BOOL managerAuthorized;
@property (nonatomic) CLLocation *currentLocation;

- (void)startUpdatingLocation;

@end
