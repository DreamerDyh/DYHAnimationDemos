//
//  DYHBaseAnimateSceneViewController.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/27.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYHBaseAnimateSceneViewController : UIViewController

@property (nonatomic, weak) UILabel *isAnimaTingTipLabel; //显示是否正在执行动画的Label

@property (nonatomic, assign) BOOL isAnimating; //是否正在执行动画

@end
