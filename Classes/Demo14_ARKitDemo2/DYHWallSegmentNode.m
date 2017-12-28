//
//  DYHWallSegmentNode.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHWallSegmentNode.h"

@interface DYHWallSegmentNode()

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) BOOL hideUpperX;

@end

@implementation DYHWallSegmentNode

- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height hideUpperX:(BOOL)hideUpperX
{
    if (self = [super init]) {
        self.width = width;
        self.height = height;
        self.hideUpperX = hideUpperX;
        [self setUpGeometry];
    }
    return self;
}

- (void)setUpGeometry
{
    
}

@end
