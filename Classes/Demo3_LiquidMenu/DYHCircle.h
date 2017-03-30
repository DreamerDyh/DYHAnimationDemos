//
//  DYHCircle.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/30.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 表示屏幕上的一个圆
 */
@interface DYHCircle : NSObject

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) CGFloat radius;

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius;

+ (instancetype)circleWithCenter:(CGPoint)center radius:(CGFloat)radius;

@end
