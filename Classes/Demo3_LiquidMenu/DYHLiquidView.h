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

/*
 * 已经push出来的View
 */
@property (nonatomic, weak) DYHLiquidView *pushedView;

/*
 * 代理
 */
@property (nonatomic, weak) id<DYHLiquidViewDelegate> delegate;

/*
 * 垂直偏移量 <0向上 >0向下
 */
@property (nonatomic, assign) CGFloat defaultTranslationY;

/*
 * 装载内容的View
 */
@property (nonatomic, weak) UIView *contentView;

/*
 *iconName
 */
@property (nonatomic, strong) NSString *iconName;

- (instancetype)initWithQuadWidth:(CGFloat)quadWidth contentBgColor:(UIColor *)contentBgColor;

+ (instancetype)liquidViewWithQuadWidth:(CGFloat)quadWidth contentBgColor:(UIColor *)contentBgColor;

- (void)pushLiquidView:(DYHLiquidView *)view delay:(CGFloat)delay completion:(DYHLiquidViewCompletionBlock)completion;

- (void)pushLiquidView:(DYHLiquidView *)view delay:(CGFloat)delay duration:(CGFloat)duration completion:(DYHLiquidViewCompletionBlock)completion;

- (void)popPushedViewWithDelay:(CGFloat)delay;

@end
