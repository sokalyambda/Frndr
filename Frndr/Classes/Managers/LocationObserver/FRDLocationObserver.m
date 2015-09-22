//
//  FRDLocationObserver.m
//  Frndr
//
//  Created by Eugenity on 22.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "FRDLocationObserver.h"

@interface FRDLocationObserver ()<CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation FRDLocationObserver

#pragma mark - Accessors

- (CLLocation *)currentLocation
{
    return self.locationManager.location;
}

- (BOOL)isAuthorized
{
    return [CLLocationManager authorizationStatus] == (kCLAuthorizationStatusAuthorizedAlways);
}

#pragma mark - Lifecycle

+ (FRDLocationObserver*)sharedObserver
{
    static FRDLocationObserver *locationObserver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationObserver = [[FRDLocationObserver alloc] init];
    });
    
    return locationObserver;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate           = self;
        _locationManager.distanceFilter     = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy    = kCLLocationAccuracyKilometer;
        _currentLocation = nil;
        
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [[UIApplication sharedApplication] sendAction:@selector(requestWhenInUseAuthorization)
                                                       to:_locationManager
                                                     from:self
                                                 forEvent:nil];
        }
        
        [self startUpdatingLocation];
    }
    return self;
}

#pragma mark - Actions

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    self.currentLocation = manager.location;
}

@end
