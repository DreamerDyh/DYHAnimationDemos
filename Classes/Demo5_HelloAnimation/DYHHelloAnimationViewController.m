//
//  DYHHelloAnimationViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/4/5.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHHelloAnimationViewController.h"
#import "DYHActiveButton.h"

#define kAnimationName @"kAnimationName"
#define kAnimationNameStrokeStart1 @"kAnimationNameStrokeStart1"
#define kAnimationNameStrokeStart2 @"kAnimationNameStrokeStart2"
#define kAnimationNameStrokeEnd1 @"kAnimationNameStrokeEnd1"
#define kAnimationNameStrokeEnd2 @"kAnimationNameStrokeEnd2"
#define kAnimationLongDuration 2.0f
#define kAnimationShortDuration 1.f
#define kShowingDelay 2.f

@interface DYHHelloAnimationViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UIBezierPath *helloBezierPath;

@property (nonatomic, weak) CAShapeLayer *helloLayer;

@property (nonatomic, weak) DYHActiveButton *activeButton;

@end

@implementation DYHHelloAnimationViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

#pragma mark - subviews

- (void)setUpSubviews
{
    self.helloLayer.path = self.helloBezierPath.CGPath;
    
    //button
    //button
    DYHActiveButton *btn = [DYHActiveButton new];
    [btn setTitle:@"Say Hello" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sayHello) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.buttons addObject:btn];
    self.activeButton = btn;
    
    [btn sizeToFit];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kNavHeight);
    }];
}

- (UIBezierPath *)helloBezierPath
{
    if (!_helloBezierPath) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        //h前的额外部分
        [path moveToPoint:CGPointMake(47.5, 182)];
        [path addCurveToPoint:CGPointMake(94, 246.5) controlPoint1:CGPointMake(47.5, 182) controlPoint2:CGPointMake(55, 265.5)];
        //h
        [path addCurveToPoint:CGPointMake(143, 192.5) controlPoint1:CGPointMake(143, 225) controlPoint2:CGPointMake(148, 192.5)];
        [path addCurveToPoint:CGPointMake(117, 260.5) controlPoint1:CGPointMake(124, 192.5) controlPoint2:CGPointMake(117, 260.5)];
        [path addCurveToPoint:CGPointMake(127.5, 236) controlPoint1:CGPointMake(117, 260.5) controlPoint2:CGPointMake(122, 239)];
        [path addCurveToPoint:CGPointMake(136.5, 236.5) controlPoint1:CGPointMake(127.5, 236) controlPoint2:CGPointMake(133, 234.5)];
        [path addCurveToPoint:CGPointMake(143, 260.5) controlPoint1:CGPointMake(141.5, 239) controlPoint2:CGPointMake(132.5, 257.5)];
        //e
        [path addCurveToPoint:CGPointMake(159, 237) controlPoint1:CGPointMake(159, 264) controlPoint2:CGPointMake(178, 239.5)];
        [path addCurveToPoint:CGPointMake(166, 261.5) controlPoint1:CGPointMake(152, 236.5) controlPoint2:CGPointMake(142, 251)];
        [path addCurveToPoint:CGPointMake(171, 261) controlPoint1:CGPointMake(166, 261.5) controlPoint2:CGPointMake(169, 262)];
        //ll
        [path addCurveToPoint:CGPointMake(200.5, 196) controlPoint1:CGPointMake(209, 231) controlPoint2:CGPointMake(200.5, 196)];
        [path addCurveToPoint:CGPointMake(195, 262) controlPoint1:CGPointMake(181.5, 195) controlPoint2:CGPointMake(176, 259.5)];
        [path addCurveToPoint:CGPointMake(203, 261) controlPoint1:CGPointMake(195, 262) controlPoint2:CGPointMake(200.5, 263)];
        [path addCurveToPoint:CGPointMake(227, 196) controlPoint1:CGPointMake(231, 236) controlPoint2:CGPointMake(229, 197)];
        [path addCurveToPoint:CGPointMake(221, 262) controlPoint1:CGPointMake(210, 199) controlPoint2:CGPointMake(204, 259)];
        [path addCurveToPoint:CGPointMake(238, 251) controlPoint1:CGPointMake(234, 263.5) controlPoint2:CGPointMake(238, 251)];
        //o
        [path addCurveToPoint:CGPointMake(247, 261.5) controlPoint1:CGPointMake(238, 251) controlPoint2:CGPointMake(241.5, 260.5)];
        [path addCurveToPoint:CGPointMake(245, 237) controlPoint1:CGPointMake(274, 260.5) controlPoint2:CGPointMake(253, 234)];
        [path addCurveToPoint:CGPointMake(278, 238) controlPoint1:CGPointMake(230, 247) controlPoint2:CGPointMake(255, 259)];
        //o后面的额外部分
        [path addCurveToPoint:CGPointMake(279, 349) controlPoint1:CGPointMake(317, 201) controlPoint2:CGPointMake(313, 347)];
        
        _helloBezierPath = path;
    }
    
    return _helloBezierPath;
}

- (CAShapeLayer *)helloLayer
{
    if (!_helloLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 6.f;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.strokeStart = 0.09;
        shapeLayer.strokeEnd = 0.86;
        shapeLayer.strokeColor = RGBCOLOR(238, 69, 137).CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.view.layer addSublayer:shapeLayer];
        _helloLayer = shapeLayer;
    }
    return _helloLayer;
}

#pragma mark - 回调

- (void)sayHello
{
    if (self.isAnimating) {
        return;
    }
    
    self.isAnimating = YES;
    CABasicAnimation* strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.delegate = self;
    strokeEndAnimation.duration = kAnimationLongDuration;
    strokeEndAnimation.fromValue = @(0);
    [strokeEndAnimation setValue:kAnimationNameStrokeEnd1 forKey:kAnimationName];
    [self.helloLayer addAnimation:strokeEndAnimation forKey:nil];
    
    
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if ([[anim valueForKey:kAnimationName] isEqualToString:kAnimationNameStrokeEnd1]) {
        CABasicAnimation* strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.delegate = self;
        strokeStartAnimation.fromValue = @(0);
        strokeStartAnimation.duration = kAnimationShortDuration;
        [strokeStartAnimation setValue:kAnimationNameStrokeStart1 forKey:kAnimationName];
        strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.helloLayer addAnimation:strokeStartAnimation forKey:nil];
    } else if([[anim valueForKey:kAnimationName] isEqualToString:kAnimationNameStrokeEnd2]) {
        CABasicAnimation* strokeStartAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation2.delegate = self;
        strokeStartAnimation2.toValue = @(1);
        strokeStartAnimation2.duration = kAnimationLongDuration;
        [strokeStartAnimation2 setValue:kAnimationNameStrokeStart2 forKey:kAnimationName];
        [self.helloLayer addAnimation:strokeStartAnimation2 forKey:nil];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag && [[anim valueForKey:kAnimationName] isEqualToString:kAnimationNameStrokeStart1]){
        CABasicAnimation* strokeEndAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation2.delegate = self;
        strokeEndAnimation2.duration = kAnimationLongDuration;
        strokeEndAnimation2.toValue = @(1);
        strokeEndAnimation2.beginTime = CACurrentMediaTime()+kShowingDelay;
        strokeEndAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [strokeEndAnimation2 setValue:kAnimationNameStrokeEnd2 forKey:kAnimationName];
        [self.helloLayer addAnimation:strokeEndAnimation2 forKey:nil];
    } else if(flag && [[anim valueForKey:kAnimationName] isEqualToString:kAnimationNameStrokeStart2]) {
        self.isAnimating = NO;
    }
}

@end
