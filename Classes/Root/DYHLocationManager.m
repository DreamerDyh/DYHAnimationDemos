//
//  DYHLocationManager.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/25.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHLocationManager.h"
#import <CoreLocation/CoreLocation.h>

static DYHLocationManager *_sharedManager;

@interface DYHLocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSDictionary *currentCity;

@end

@implementation DYHLocationManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedManager == nil) {
            _sharedManager = [super allocWithZone:zone];
        }
    });
    return _sharedManager;
}


+ (instancetype)sharedManager
{
    return [[self alloc]init];
}

- (id)copyWithZone:(NSZone *)zone
{
    return _sharedManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _sharedManager;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - API

- (void)locateCity
{
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你没有开启定位" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - CLLocationManagerDelegate

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            if (placeMark.locality) {
                self.currentCity = @{
                                    kCityKeyName:placeMark.locality,
                                    kCityKeyLatitude:@(placeMark.location.coordinate.latitude),
                                    kCityKeyLongitude:@(placeMark.location.coordinate.longitude)
                                    };
            }
            if (self.currentCity) {
                [[NSNotificationCenter defaultCenter] postNotificationName:klocateCitySuccessNotification object:self.currentCity];
            }
        } else {
            self.currentCity = @{
                                 kCityKeyName:@"火星",
                                 kCityKeyLatitude:@(currentLocation.coordinate.latitude),
                                 kCityKeyLongitude:@(currentLocation.coordinate.longitude)
                                 };
            if (self.currentCity) {
                [[NSNotificationCenter defaultCenter] postNotificationName:klocateCitySuccessNotification object:self.currentCity];
            }
        }
    }];
}

- (NSDictionary *)fetchCurrentCity
{
    return self.currentCity;
}

@end
