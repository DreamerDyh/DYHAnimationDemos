//
//  DYHPageViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/5/10.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHPageViewController.h"

#import "DYHPageView.h"

@interface DYHPageViewController ()

@property (nonatomic, weak) DYHPageView *pageView;

@end

@implementation DYHPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageUrls = @[@"preview_1",@"preview_2",@"preview_3",@"preview_4"];
    DYHPageView *pageView = [DYHPageView pageViewWithImageUrls:imageUrls frame:CGRectMake(0, 150, self.view.bounds.size.width, 400.f)];
    [self.view addSubview:pageView];
    self.pageView = pageView;
    [self.pageView reloadData];
    [self.pageView jumpToIndex:1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.pageView changeClipsToBoundsState:YES];
}

@end
