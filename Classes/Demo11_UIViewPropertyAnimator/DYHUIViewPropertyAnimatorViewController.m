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

@property (nonatomic, weak) UISlider *slider;

@property (nonatomic, strong) UIViewPropertyAnimator *animator;

@end

@implementation DYHUIViewPropertyAnimatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    //[self setAnimationByTraditionalWay];
    //[self setAnimationByNewWay];
    [self quicklySetAnimationWithSelfTimingFunction];
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
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-200.f)/2.f, CGRectGetHeight(self.view.bounds)-60.f, 200.f, 30.f)];
    [slider addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    self.slider = slider;
}

- (void)setAnimationByTraditionalWay
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.duration = 1.f;
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(M_PI);
    [self.imageView.layer addAnimation:rotationAnimation forKey:nil];
    self.imageView.layer.speed = 0;
}

- (void)setAnimationByNewWay
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:1.f curve:UIViewAnimationCurveEaseOut animations:^{
        self.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }];
    [animator pauseAnimation];
    self.animator = animator;
}

- (void)slide:(UISlider *)slider
{
    //self.imageView.layer.timeOffset = (CFTimeInterval)slider.value;
    self.animator.fractionComplete = (CGFloat)slider.value;
}

- (void)quicklySetAnimationWithSelfTimingFunction
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:1.f controlPoint1:CGPointMake(0.3, 0.5) controlPoint2:CGPointMake(0.9, 0.5) animations:^{
        self.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }];
    [animator startAnimation];
}


@end
