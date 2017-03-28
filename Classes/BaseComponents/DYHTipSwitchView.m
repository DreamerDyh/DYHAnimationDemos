//
//  DYHTipSwitchView.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHTipSwitchView.h"

@implementation DYHTipSwitchView

#pragma mark - subview

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    //开关
    UISwitch *switcher = [UISwitch new];
    [switcher sizeToFit];
    [self addSubview:switcher];
    self.switcher = switcher;
    
    [switcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //tipLabel
    UILabel *tipLabel = [UILabel new];
    tipLabel.font = SYSFONT(15.f);
    tipLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(switcher.mas_left).offset(-10.f);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

@end
