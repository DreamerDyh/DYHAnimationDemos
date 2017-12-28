//
//  DYHBoxRoomNode.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHBoxRoomNode.h"

#define kDebugOperator 0.01
#define kDefaultSide 3.f
#define kDefaultThickness (0.1f * kDebugOperator)

@interface DYHBoxRoomNode()

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat length;

@property (nonatomic, assign) CGFloat height;

@end

@implementation DYHBoxRoomNode

- (instancetype)initWithWidth:(CGFloat)width length:(CGFloat)length height:(CGFloat)height
{
    if (self = [super init]) {
        self.width = (width > 0 ? width : kDefaultSide) * kDebugOperator;
        self.length = (length > 0 ? length : kDefaultSide) * kDebugOperator;
        self.height = (height > 0 ? height : kDefaultSide) * kDebugOperator;
        [self setUpGeometry];
    }
    return self;
}

#pragma mark - SetUP

- (void)setUpGeometry
{
    CGFloat halfThick = kDefaultThickness * 0.5f;
    //地板
    SCNNode *floor = [self planeSegmentNodeWithWidth:self.width length:self.length hideUpperY:NO];
    [self addChildNode:floor];
    floor.position = SCNVector3Make(0, halfThick, 0);
}

#pragma mark - Nodes

- (SCNNode *)planeSegmentNodeWithWidth:(CGFloat)width length:(CGFloat)length hideUpperY:(BOOL)hideUpperY
{
    SCNBox *box = [SCNBox boxWithWidth:width height:kDefaultThickness length:length chamferRadius:0.f];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"saber"];
    SCNNode *node = [SCNNode nodeWithGeometry:box];
    return node;
}

- (SCNNode *)wallSegmentNodeWithWidth:(CGFloat)width length:(CGFloat)length hideUpperX:(BOOL)hideUpperX
{
    return nil;
}

@end
