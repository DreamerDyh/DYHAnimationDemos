//
//  DYHEasyAnimator.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/5/16.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYHEasyAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPush;

- (instancetype)initWithIsPush:(BOOL)isPush;

+ (instancetype)animatorWithIsPush:(BOOL)isPush;

@end
