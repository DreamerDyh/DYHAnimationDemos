//
//  DYHBaseDestinationViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/5/16.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHBaseDestinationViewController.h"
#import <SceneKit/SceneKit.h>

@interface DYHBaseDestinationViewController ()

@end

@implementation DYHBaseDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UILabel *label = [UILabel new];
    label.font = SYSFONT(45.f);
    label.text = @"This is Destination";
    label.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
    }];
}

@end
