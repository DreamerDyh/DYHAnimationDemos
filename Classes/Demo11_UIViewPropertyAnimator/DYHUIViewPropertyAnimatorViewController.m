//
//  DYHUIViewPropertyAnimatorViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/7.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHUIViewPropertyAnimatorViewController.h"

@interface DYHUIViewPropertyAnimatorViewController ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation DYHUIViewPropertyAnimatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

- (void)setUpSubviews
{
    UIImageView *imageView = [UIImageView new];
    imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 165.f, 307.f)].CGPath;
    imageView.layer.shadowOpacity = 0.5f;
    imageView.layer.shadowOffset = CGSizeMake(0, 2.f);
    imageView.layer.shadowRadius = 2.f;
    imageView.image = [UIImage imageNamed:@"saber"];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(165.f, 307.f));
    }];
}



@end
