//
//  Easy3DViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/21.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "Easy3DViewController.h"

@interface Easy3DViewController ()

@end

@implementation Easy3DViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubViews];
}

#pragma mark - subViews

- (void)setUpSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Easy3DTransform";
}

@end
