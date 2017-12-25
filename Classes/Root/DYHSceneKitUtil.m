//
//  DYHSceneKitUtil.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/10/11.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHSceneKitUtil.h"
#import <SceneKit/SceneKit.h>

@implementation DYHSceneKitUtil


+ (void)showAxisOnScene:(SCNScene *)scene length:(CGFloat)length
{
    SCNNode* yAxisNode = [self fitCapsuleNodeWithColor:[UIColor redColor] length:length];
    [scene.rootNode addChildNode:yAxisNode];
    
    SCNNode* xAxisNode = [self fitCapsuleNodeWithColor:[UIColor blueColor] length:length];
    xAxisNode.rotation = SCNVector4Make(0, 0, 1.f, -M_PI_2);
    [scene.rootNode addChildNode:xAxisNode];
    
    SCNNode* zAxisNode = [self fitCapsuleNodeWithColor:[UIColor greenColor] length:length];
    zAxisNode.rotation = SCNVector4Make(1.f, 0, 0, M_PI_2);
    [scene.rootNode addChildNode:zAxisNode];
}

+ (void)showAxisOnScene:(SCNScene *)scene
{
    [self showAxisOnScene:scene length:2.f];
}

+ (SCNNode *)fitCapsuleNodeWithColor:(UIColor *)color length:(CGFloat)length
{
    CGFloat axisHeight = length > 0 ? length : 2.f;
    SCNCapsule *axis = [SCNCapsule capsuleWithCapRadius:0.02f height:axisHeight];
    axis.firstMaterial.diffuse.contents = color;
    SCNNode* axisNode = [SCNNode nodeWithGeometry:axis];
    axisNode.pivot = SCNMatrix4MakeTranslation(0, -axisHeight/2.f, 0);
    return axisNode;
}

@end
