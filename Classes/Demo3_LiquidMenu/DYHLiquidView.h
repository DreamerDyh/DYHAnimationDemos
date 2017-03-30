//
//  DYHLiquidView.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/30.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DYHLiquidView;

typedef void(^DYHLiquidViewCompletionBlock)(UIView *pushedView);

@protocol DYHLiquidViewDelegate <NSObject>

@optional
- (void)liquidViewWasClicked:(DYHLiquidView *)liquidView;

@end

@interface DYHLiquidView : UIView

//push出来的任意View
@property (nonatomic, strong) UIView *pushedView;

@property (nonatomic, weak) id<DYHLiquidViewDelegate> delegate;

- (void)pushView:(UIView *)view WithCompletion:(DYHLiquidViewCompletionBlock)completion;

@end
