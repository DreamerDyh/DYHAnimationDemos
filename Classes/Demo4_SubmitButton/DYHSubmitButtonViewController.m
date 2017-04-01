//
//  DYHSubmitButtonViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/4/1.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHSubmitButtonViewController.h"
#import "DYHAnimateSubmitButton.h"

@interface DYHSubmitButtonViewController ()

@property (nonatomic, weak) DYHAnimateSubmitButton *submitButton;

@end

@implementation DYHSubmitButtonViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

#pragma mark - subviews

- (void)setUpSubviews
{
    DYHAnimateSubmitButton *submitButtton = [DYHAnimateSubmitButton new];
    [submitButtton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [submitButtton setTitle:@"submit" forState:UIControlStateNormal];
    submitButtton.center = CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f);
    submitButtton.bounds = CGRectMake(0, 0, 150.f, 45.f);
    [self.view addSubview:submitButtton];
    self.submitButton = submitButtton;
}

#pragma mark - 回调

- (void)submit:(UIButton *)sender
{

}
@end