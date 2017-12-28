//
//  DYHWallSegmentNode.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#define kWallThickness 0.2f
#define kWallMaskThickness 0.02f

/*
 * 表示一块指定大小的墙体
 */
@interface DYHWallSegmentNode : SCNNode

- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height hideUpperX:(BOOL)hideUpperX;

@end
