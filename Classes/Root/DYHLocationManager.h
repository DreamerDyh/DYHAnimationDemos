//
//  DYHLocationManager.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/25.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define klocateCitySuccessNotification @"klocateCitySuccessNotification"

#define kCityKeyName @"kCityKeyName"
#define kCityKeyLongitude @"kCityKeyLongitude"
#define kCityKeyLatitude @"kCityKeyLatitude"

@interface DYHLocationManager : NSObject

+ (instancetype)sharedManager;

- (void)locateCity;

- (NSDictionary *)fetchCurrentCity;

@end
