//
//  DYHSceneKitUtil.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/10/11.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCNScene;

@interface DYHSceneKitUtil : NSObject

+ (void)showAxisOnScene:(SCNScene *)scene;

+ (void)showAxisOnScene:(SCNScene *)scene length:(CGFloat)length;

@end
