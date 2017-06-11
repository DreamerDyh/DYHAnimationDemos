//
//  DYHEasyTransitionViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/5/15.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHEasyTransitionViewController.h"
#import "DYHActiveButton.h"
#import "DYHBaseDestinationViewController.h"
#import "DYHEasyAnimator.h"

@interface DYHEasyTransitionViewController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) DYHActiveButton *btn;

@end

@implementation DYHEasyTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //button
    DYHActiveButton *btn = [DYHActiveButton new];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushToDestination) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //[self.buttons addObject:btn];
    self.btn = btn;
    self.navigationController.delegate = self;
    
    [btn sizeToFit];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
}

- (void)pushToDestination
{
    [self.navigationController pushViewController:[DYHBaseDestinationViewController new] animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        NSLog(@"POP");
        return [DYHEasyAnimator animatorWithIsPush:NO];
    } else if(operation == UINavigationControllerOperationPush) {
        NSLog(@"PUSH");
        return [DYHEasyAnimator animatorWithIsPush:YES];
    }
    return nil;
}

@end
