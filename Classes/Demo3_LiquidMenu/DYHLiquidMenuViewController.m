//
//  DYHLiquidMenuViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/30.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHLiquidMenuViewController.h"
#import "DYHLiquidView.h"

@interface DYHLiquidMenuViewController ()<DYHLiquidViewDelegate>

@end

@implementation DYHLiquidMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DYHLiquidView* liquidView = [DYHLiquidView liquidViewWithQuadWidth:50.f contentBgColor:LiquidColor];
    liquidView.delegate = self;
    [self.view addSubview:liquidView];
    liquidView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*0.7);

}

#pragma mark - DYHLiquidViewDelegate

- (void)liquidViewWasClicked:(DYHLiquidView *)liquidView
{
    DYHLiquidView *view = [DYHLiquidView liquidViewWithQuadWidth:40.f contentBgColor:LiquidColor];
    [liquidView pushLiquidView:view delay:0 completion:nil];
    [view pushLiquidView:[DYHLiquidView liquidViewWithQuadWidth:40.f contentBgColor:[UIColor redColor]] delay:0.1f completion:nil];
}

@end
