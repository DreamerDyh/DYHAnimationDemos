//
//  DYHBoxRoomNode.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHBoxRoomNode.h"

#define kDebugOperator 1.f
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

@property (nonatomic, weak) SCNNode *leftWall;

@property (nonatomic, weak) SCNNode *rightWall;

@property (nonatomic, weak) SCNNode *backWall;

@property (nonatomic, weak) SCNNode *leftFrontWall;

@property (nonatomic, weak) SCNNode *rightFrontWall;

@property (nonatomic, weak) SCNNode *topFrontWall;

@property (nonatomic, weak) SCNNode *bottomNodeWall;

@property (nonatomic, weak) SCNNode *roof;

@property (nonatomic, weak) SCNNode *floor;

@end

@implementation DYHBoxRoomNode

#pragma mark - Init

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

+ (instancetype)boxNodeWithWidth:(CGFloat)width length:(CGFloat)length height:(CGFloat)height
{
    return [[self alloc] initWithWidth:width length:length height:height];
}

#pragma mark - Set

- (void)setSkyBoxImages:(NSArray<NSString *> *)skyBoxImages
{
    _skyBoxImages = skyBoxImages;
    [self handleSkyBoxImages];
}

#pragma mark - SetUP

- (void)setUpGeometry
{
    CGFloat halfThick = kDefaultThickness * 0.5f;
    //地板基座
    SCNNode *floor = [self structureSegmentNodeWithWidth:self.width height:kDefaultThickness length:self.length hideOption:kHideOptionMinusY];
    [self addChildNode:floor];
    floor.position = SCNVector3Make(0, halfThick, 0);
    self.floor = floor;
    
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
    self.leftWall = leftWall;
    leftWall.position = SCNVector3Make(-lrWallAbsoluteX, wallHeight/2.f, 0);
    
    //右墙
    SCNNode *rightWall = [self structureSegmentNodeWithWidth:kDefaultThickness height:wallHeight length:self.length hideOption:kHideOptionUpperX];
    [self addChildNode:rightWall];
    self.rightWall = rightWall;
    rightWall.position = SCNVector3Make(lrWallAbsoluteX, wallHeight/2.f, 0);
    
    //后墙
    SCNNode *backWall = [self structureSegmentNodeWithWidth:self.width + 2*kDefaultThickness height:wallHeight length:kDefaultThickness hideOption:kHideOptionMinusZ];
    [self addChildNode:backWall];
    self.backWall = backWall;
    backWall.position = SCNVector3Make(0, wallHeight/2.f, -fbWallAbsoluteZ);
    
    //左前脸
    SCNNode *leftFrontWall = [self structureSegmentNodeWithWidth:frontWallPartW height:wallHeight length:kDefaultThickness hideOption:kHideOptionUpperZ];
    [self addChildNode:leftFrontWall];
    self.leftFrontWall = leftFrontWall;
    leftFrontWall.position = SCNVector3Make(-frontWallPartAbsoluteX, wallHeight/2.f, fbWallAbsoluteZ);
    
    //右前脸
    SCNNode *rightFrontWall = [self structureSegmentNodeWithWidth:frontWallPartW height:wallHeight length:kDefaultThickness hideOption:kHideOptionUpperZ];
    [self addChildNode:rightFrontWall];
    self.rightFrontWall = rightFrontWall;
    rightFrontWall.position = SCNVector3Make(frontWallPartAbsoluteX, wallHeight/2.f, fbWallAbsoluteZ);
    
    //上前脸
    SCNNode *topFrontWall = [self structureSegmentNodeWithWidth:self.doorWidth height:self.height-self.doorHeight length:kDefaultThickness hideOption:kHideOptionUpperZ];
    [self addChildNode:topFrontWall];
    self.topFrontWall = topFrontWall;
    topFrontWall.position = SCNVector3Make(0, (self.height + self.doorHeight ) / 2.f + kDefaultThickness, fbWallAbsoluteZ);
    
    //下前脸
    SCNNode *bottomNodeWall = [self structureSegmentNodeWithWidth:self.doorWidth height:kDefaultThickness length:kDefaultThickness hideOption:kHideOptionUpperZ];
    [self addChildNode:bottomNodeWall];
    self.bottomNodeWall = bottomNodeWall;
    bottomNodeWall.position = SCNVector3Make(0, halfThick, fbWallAbsoluteZ);
    
    //屋顶
    SCNNode *roof = [self structureSegmentNodeWithWidth:self.width height:kDefaultThickness length:self.length hideOption:kHideOptionUpperY];
    [self addChildNode:roof];
    self.roof = roof;
    roof.position = SCNVector3Make(0, self.height + halfThick, 0);
}

#pragma mark - Nodes

- (SCNNode *)structureSegmentNodeWithWidth:(CGFloat)width height:(CGFloat)height length:(CGFloat)length hideOption:(kHideOption)hideOption
{
    SCNBox *box = [SCNBox boxWithWidth:width height:height length:length chamferRadius:0.f];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"saber"];
    box.firstMaterial.writesToDepthBuffer = YES;
    box.firstMaterial.readsFromDepthBuffer = YES;
    SCNNode *node = [SCNNode nodeWithGeometry:box];
    node.renderingOrder = 200;
    
    SCNBox *maskBox = [SCNBox boxWithWidth:width height:height length:length chamferRadius:0.f];
    maskBox.firstMaterial.diffuse.contents = [UIColor redColor];
    maskBox.firstMaterial.transparency = 0.000001f;
    //just try
    maskBox.firstMaterial.writesToDepthBuffer = YES;
    SCNNode *mask = [SCNNode nodeWithGeometry:maskBox];
    mask.renderingOrder = 100;
    [node addChildNode:mask];
    
    switch (hideOption) {
        case kHideOptionUpperZ:
        case kHideOptionMinusZ:
        {
            mask.position = SCNVector3Make(0, 0, hideOption == kHideOptionUpperZ ? length : -length);
            
        }break;
        case kHideOptionUpperX:
        case kHideOptionMinusX:
        {
            maskBox.length += 2.1*kDefaultThickness;
            mask.position = SCNVector3Make(hideOption == kHideOptionUpperX ? width : -width, 0, 0);
        }break;
        case kHideOptionUpperY:
        case kHideOptionMinusY:
        {
            maskBox.width += 2.1*kDefaultThickness;
            maskBox.length += 2.1*kDefaultThickness;
            mask.position = SCNVector3Make(0, hideOption == kHideOptionUpperY ? height : -height, 0);
            
        }break;
        default:
        break;
    }
    return node;
}

#pragma mark - Tool

- (void)handleSkyBoxImages
{
    if (!(self.skyBoxImages.count >= 6)) {
        return;
    }
    
    //+z
    //leftFrontWall;
    //rightFrontWall;
    //topFrontWall;
    //bottomNodeWall;
    self.leftFrontWall.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[0]];
    self.rightFrontWall.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[0]];
    self.topFrontWall.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[0]];
    self.bottomNodeWall.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[0]];
    
    //-z
    //backWall;
    self.backWall.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[1]];
    
    //+x
    //rightWall;
    self.rightWall.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[2]];
    
    //-x
    //leftWall;
    self.leftWall.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[3]];
    
    //+y
    //roof;
    self.roof.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[4]];
    
    //-y
    //floor
    self.floor.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.skyBoxImages[5]];
}

@end
