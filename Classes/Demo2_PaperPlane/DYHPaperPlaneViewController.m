//
//  DYHPaperPlaneViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHPaperPlaneViewController.h"
#import "DYHActiveButton.h"
#import "DYHTipSwitchView.h"

@interface DYHPaperPlaneViewController ()<CAAnimationDelegate>

@property (nonatomic, weak) UIImageView *airplaneImageView;

@property (nonatomic, weak) CAShapeLayer *pathLayer;

@property (nonatomic, strong) UIBezierPath *flyPath;

@property (nonatomic, weak) DYHTipSwitchView *switchView;

@end

@implementation DYHPaperPlaneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

#pragma mark - Subviews

- (void)setUpSubviews
{
    
    self.view.backgroundColor = RGBCOLOR(198, 245, 245);
    
    //airplane
    UIImageView *airplaneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paper_plane_80px"]];
    [airplaneImageView sizeToFit];
    airplaneImageView.transform = CGAffineTransformMakeRotation(M_PI/8);
    [self.view addSubview:airplaneImageView];
    self.airplaneImageView = airplaneImageView;
    
    CGSize airplaneSize = airplaneImageView.bounds.size;
    airplaneImageView.center = CGPointMake(airplaneSize.width/2, self.view.bounds.size.height - kNavHeight);
    
    //飞行轨迹
    UIBezierPath *flyPath = [UIBezierPath bezierPath];
    [flyPath moveToPoint:airplaneImageView.center];
    [flyPath addCurveToPoint:CGPointMake(289.f, 63.f) controlPoint1:airplaneImageView.center controlPoint2:CGPointMake(498.f, 164.f)];
    [flyPath addCurveToPoint:CGPointMake(375.f, 393.f) controlPoint1:CGPointMake(112.f, 28.f) controlPoint2:CGPointMake(375.f, 393.f)];
    self.flyPath = flyPath;
    
    //轨迹可视化
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    pathLayer.lineDashPattern = @[@(3),@(1)];
    pathLayer.lineWidth = 1.f;
    pathLayer.path = flyPath.CGPath;
    pathLayer.hidden = YES;
    [self.view.layer insertSublayer:pathLayer below:airplaneImageView.layer];
    self.pathLayer = pathLayer;
    
    //button
    DYHActiveButton *btn = [DYHActiveButton new];
    [btn setTitle:@"起飞" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(takeOff) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.buttons addObject:btn];
    
    [btn sizeToFit];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kNavHeight);
    }];
    
    //tipSwitch
    DYHTipSwitchView *switchView = [DYHTipSwitchView new];
    switchView.tipLabel.text = @"飞行轨迹开关";
    [switchView.switcher addTarget:self action:@selector(swichChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView];
    self.switchView = switchView;
    
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(55.f);
        make.top.equalTo(btn.mas_bottom).offset(5.f);
        make.size.mas_equalTo(switchView.switcher.bounds.size);
    }];
    
}

#pragma mark - 回调

- (void)takeOff
{
    if (self.isAnimating) {
        return;
    }
    
    self.isAnimating = YES;
    CAKeyframeAnimation *flyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    flyAnimation.duration = 3.f;
    flyAnimation.path = self.flyPath.CGPath;
    flyAnimation.rotationMode = kCAAnimationRotateAuto;
    flyAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5 :0.9 :0.5];
    flyAnimation.delegate = self;
    [self.airplaneImageView.layer addAnimation:flyAnimation forKey:nil];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.isAnimating = NO;
    }
}

- (void)swichChange:(UISwitch *)sender
{
    if (sender.on) {
        self.pathLayer.hidden = NO;
    } else {
        self.pathLayer.hidden = YES;
    }
}


@end
