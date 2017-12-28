//
//  DYHBoxRoomNode.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface DYHBoxRoomNode : SCNNode

/*
 * 宽 x 长 x 高
 * 其中宽为带门的一面 也是正对观察方向的一面
 */
- (instancetype)initWithWidth:(CGFloat)width length:(CGFloat)length height:(CGFloat)height;

@end
