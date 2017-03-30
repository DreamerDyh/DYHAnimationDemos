
//
//  DYHCircle.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/30.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHCircle.h"

@implementation DYHCircle

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius
{
    if (self = [super init]) {
        self.center = center;
        self.radius = radius;
    }
    return self;
}

+ (instancetype)circleWithCenter:(CGPoint)center radius:(CGFloat)radius
{
    return [[self alloc] initWithCenter:center radius:radius];
}

@end
