//
//  DYHBoxRoomNode.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHBoxRoomNode.h"

#define kDebugOperator 3.f
#define kDefaultSide 3.f
#define kDefaultThickness (0.05f * kDebugOperator)

typedef NS_ENUM(NSUInteger, kHideOption) {
    kHideOptionUpperX = 1,
    kHideOptionMinusX,
    kHideOptionUpperY,
    kHideOptionMinusY,
    kHideOptionUpperZ,
    kHideOptionMinusZ
};

@interface DYHBoxRoomNode()

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat length;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat doorWidth;

@property (nonatomic, assign) CGFloat doorHeight;

@end

@implementation DYHBoxRoomNode

- (instancetype)initWithWidth:(CGFloat)width length:(CGFloat)length height:(CGFloat)height
{
    if (self = [super init]) {
        self.width = (width > 0 ? width : kDefaultSide) * kDebugOperator;
        self.length = (length > 0 ? length : kDefaultSide) * kDebugOperator;
        self.height = (height > 0 ? height : kDefaultSide) * kDebugOperator;
        self.doorWidth = self.width / 3.f;
        self.doorHeight = (self.height / 3.f) * 2.f;
        [self setUpGeometry];
    }
    return self;
}

#pragma mark - SetUP

- (void)setUpGeometry
{
    CGFloat halfThick = kDefaultThickness * 0.5f;
    //地板基座
    SCNNode *floor = [self structureSegmentNodeWithWidth:self.width height:kDefaultThickness length:self.length hideOption:kHideOptionMinusY];
    [self addChildNode:floor];
    floor.position = SCNVector3Make(0, halfThick, 0);
    
    
    //复用参数计算
    //墙高
    CGFloat wallHeight = self.height + kDefaultThickness;
    //左右墙X绝对值
    CGFloat lrWallAbsoluteX = (self.width + kDefaultThickness)/2.f;
    //前后墙Z绝对值
    CGFloat fbWallAbsoluteZ = (self.length + kDefaultThickness)/2.f;
    //前脸宽度
    CGFloat frontWallPartW = kDefaultThickness + (self.width - self.doorWidth)/2.f;
    //前脸X绝对值
    CGFloat frontWallPartAbsoluteX = (self.doorWidth + frontWallPartW) / 2.f;
    
    //左墙
    SCNNode *leftWall = [self structureSegmentNodeWithWidth:kDefaultThickness height:wallHeight length:self.length hideOption:kHideOptionMinusX];
    [self addChildNode:leftWall];
    leftWall.position = SCNVector3Make(-lrWallAbsoluteX, wallHeight/2.f, 0);
    
    //右墙
    SCNNode *rightWall = [self structureSegmentNodeWithWidth:kDefaultThickness height:wallHeight length:self.length hideOption:kHideOptionUpperX];
    [self addChildNode:rightWall];
    rightWall.position = SCNVector3Make(lrWallAbsoluteX, wallHeight/2.f, 0);
    
    //后墙
    SCNNode *backWall = [self structureSegmentNodeWithWidth:self.width + 2*kDefaultThickness height:wallHeight length:kDefaultThickness hideOption:kHideOptionMinusZ];
    [self addChildNode:backWall];
    backWall.position = SCNVector3Make(0, wallHeight/2.f, -fbWallAbsoluteZ);
    
    //左前脸
    SCNNode *leftFrontWall = [self structureSegmentNodeWithWidth:frontWallPartW height:wallHeight length:kDefaultThickness hideOption:kHideOptionUpperZ];
    [self addChildNode:leftFrontWall];
    leftFrontWall.position = SCNVector3Make(-frontWallPartAbsoluteX, wallHeight/2.f, fbWallAbsoluteZ);
    
    //右前脸
    SCNNode *rightFrontWall = [self structureSegmentNodeWithWidth:frontWallPartW height:wallHeight length:kDefaultThickness hideOption:kHideOptionUpperZ];
    [self addChildNode:rightFrontWall];
    rightFrontWall.position = SCNVector3Make(frontWallPartAbsoluteX, wallHeight/2.f, fbWallAbsoluteZ);
    
    //上前脸
    SCNNode *topFrontWall = [self structureSegmentNodeWithWidth:self.doorWidth height:self.height-self.doorHeight length:kDefaultThickness hideOption:kHideOptionUpperZ];
    [self addChildNode:topFrontWall];
    topFrontWall.position = SCNVector3Make(0, (self.height + self.doorHeight ) / 2.f + kDefaultThickness, fbWallAbsoluteZ);
    
    //下前脸
    SCNNode *bottomNodeWall = [self structureSegmentNodeWithWidth:self.doorWidth height:kDefaultThickness length:kDefaultThickness hideOption:kHideOptionUpperZ];
    [self addChildNode:bottomNodeWall];
    bottomNodeWall.position = SCNVector3Make(0, halfThick, fbWallAbsoluteZ);
    
    //屋顶
    SCNNode *roof = [self structureSegmentNodeWithWidth:self.width + 2*kDefaultThickness height:kDefaultThickness length:self.length + 2*kDefaultThickness hideOption:kHideOptionUpperY];
    [self addChildNode:roof];
    roof.position = SCNVector3Make(0, wallHeight + halfThick, 0);
}

#pragma mark - Nodes

- (SCNNode *)structureSegmentNodeWithWidth:(CGFloat)width height:(CGFloat)height length:(CGFloat)length hideOption:(kHideOption)hideOption
{
    SCNBox *box = [SCNBox boxWithWidth:width height:height length:length chamferRadius:0.f];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"saber"];
    SCNNode *node = [SCNNode nodeWithGeometry:box];
    return node;
}

@end
