//
//  DYHLiquidView.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/30.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHLiquidView.h"

@implementation DYHLiquidView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(liquidViewWasClicked:)]) {
        [self.delegate liquidViewWasClicked:self];
    }
}

- (void)pushView:(UIView *)view completion:(DYHLiquidViewCompletionBlock)completion
{
    
}

@end
