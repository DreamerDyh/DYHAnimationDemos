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
    
    DYHLiquidView* liquidView = [DYHLiquidView new];
    liquidView.delegate = self;
    liquidView.backgroundColor = [UIColor redColor];
    [self.view addSubview:liquidView];
    
    [liquidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

#pragma mark - DYHLiquidViewDelegate

- (void)liquidViewWasClicked:(DYHLiquidView *)liquidView
{
    
}

@end
