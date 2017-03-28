//
//  DYHBaseAnimateSceneViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/27.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHBaseAnimateSceneViewController.h"

@interface DYHBaseAnimateSceneViewController ()

@end

@implementation DYHBaseAnimateSceneViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

#pragma mark - Setter / Getter

- (void)setIsAnimating:(BOOL)isAnimating
{
    _isAnimating = isAnimating;
    
    self.isAnimaTingTipLabel.text = isAnimating ? @"⭕️正在执行动画..." : @"⚠️动画执行结束";
    
    if (isAnimating) {
        for (UIButton *button in self.buttons) {
            button.enabled = NO;
        }
    } else {
        for (UIButton *button in self.buttons) {
            button.enabled = YES;
        }
    }

}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

#pragma mark - Subview

- (void)setUpSubviews
{
    //动画状态提示Label
    UILabel *isAnimaTingTipLabel = [UILabel new];
    isAnimaTingTipLabel.font = SYSFONT(15.f);
    isAnimaTingTipLabel.backgroundColor = [UIColor darkGrayColor];
    isAnimaTingTipLabel.textColor = [UIColor whiteColor];
    isAnimaTingTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:isAnimaTingTipLabel];
    self.isAnimaTingTipLabel = isAnimaTingTipLabel;
    
    [isAnimaTingTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset( self.navigationController ? kNavHeight : 0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width);
    }];
    
}

@end
