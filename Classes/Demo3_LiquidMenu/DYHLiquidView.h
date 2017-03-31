//
//  DYHLiquidView.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/30.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYHCircle.h"

#define LiquidColor RGBCOLOR(146, 167, 248)

/*
 * 暂不支持autoLayout
 */

@class DYHLiquidView;

typedef void(^DYHLiquidViewCompletionBlock)(DYHLiquidView *pushedView);

@protocol DYHLiquidViewDelegate <NSObject>

@optional
- (void)liquidViewWasClicked:(DYHLiquidView *)liquidView;

@end

@interface DYHLiquidView : UIView

@property (nonatomic, weak) DYHLiquidView *pushedView;

@property (nonatomic, weak) id<DYHLiquidViewDelegate> delegate;

@property (nonatomic, assign) CGFloat defaultTranslationY;

@property (nonatomic, weak) UIView *contentView;

- (instancetype)initWithQuadWidth:(CGFloat)quadWidth contentBgColor:(UIColor *)contentBgColor;

+ (instancetype)liquidViewWithQuadWidth:(CGFloat)quadWidth contentBgColor:(UIColor *)contentBgColor;

- (void)pushLiquidView:(DYHLiquidView *)view delay:(CGFloat)delay completion:(DYHLiquidViewCompletionBlock)completion;

@end
