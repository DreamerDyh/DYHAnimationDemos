//
//  DYHSlowLiquidBallViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/4/20.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHSlowLiquidBallViewController.h"
#import "DYHLiquidView.h"

@interface DYHSlowLiquidBallViewController ()<DYHLiquidViewDelegate>

@property (nonatomic, weak) DYHLiquidView *rootLiquidView;

@property (nonatomic, strong) DYHLiquidView *childLiquidView;

@property (nonatomic, assign) BOOL pushed;

@end

@implementation DYHSlowLiquidBallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将根view添加好
    DYHLiquidView* liquidView = [DYHLiquidView liquidViewWithQuadWidth:100.f contentBgColor:LiquidColor];
    liquidView.delegate = self;
    [self.view addSubview:liquidView];
    liquidView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*0.7);
    self.rootLiquidView = liquidView;
    
    self.childLiquidView = [DYHLiquidView liquidViewWithQuadWidth:100.f contentBgColor:LiquidColor];

}

#pragma mark - DYHLiquidViewDelegate
- (void)liquidViewWasClicked:(DYHLiquidView *)liquidView
{
    if (self.isAnimating) {
        return;
    }
    if (!self.pushed) {
        self.isAnimating = YES;
         [liquidView pushLiquidView:self.childLiquidView delay:0.f duration:3.f translationY:-300.f completion:^(DYHLiquidView *pushedView) {
             self.isAnimating = NO;
             self.pushed = YES;
         }];
    } else {
        self.isAnimating = YES;
        [liquidView popPushedViewWithDelay:0.0f completion:^(DYHLiquidView *pushedView) {
            self.isAnimating = NO;
            self.pushed = NO;
        }];
    }
    
   
}

@end
