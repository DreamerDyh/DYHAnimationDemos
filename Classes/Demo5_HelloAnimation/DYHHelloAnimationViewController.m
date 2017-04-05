//
//  DYHHelloAnimationViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/4/5.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHHelloAnimationViewController.h"

@interface DYHHelloAnimationViewController ()

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
    UIBezierPath *path = [self helloBezierPath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 6.f;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.strokeColor = RGBCOLOR(238, 69, 137).CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}

- (UIBezierPath *)helloBezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //h
    [path moveToPoint:CGPointMake(94, 246.5)];
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
    return path;
}

@end
