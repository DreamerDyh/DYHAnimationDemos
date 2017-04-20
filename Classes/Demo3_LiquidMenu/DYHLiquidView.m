//
//  DYHLiquidView.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/30.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHLiquidView.h"
@interface DYHLiquidView()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSInteger animationCount;

@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@property (nonatomic, weak) UIImageView *iconView;

@end

@implementation DYHLiquidView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpDatas];
    }
    return self;
}

- (instancetype)initWithQuadWidth:(CGFloat)quadWidth contentBgColor:(UIColor *)contentBgColor
{
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, quadWidth, quadWidth);
        self.contentView.backgroundColor = contentBgColor;
    }
    return self;
}

+ (instancetype)liquidViewWithQuadWidth:(CGFloat)quadWidth contentBgColor:(UIColor *)contentBgColor
{
    return [[self alloc] initWithQuadWidth:quadWidth contentBgColor:contentBgColor];
}

- (void)setUpDatas
{
    self.defaultTranslationY = -70.f;
    
    //添加一个contentView
    UIView* contentView = [UIView new];
    [self addSubview:contentView];
    self.contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    //添加一个iconView
    UIImageView* iconView = [UIImageView new];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - Setter/ Getter

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.layer.cornerRadius = bounds.size.height / 2.f;
    self.contentView.layer.cornerRadius = bounds.size.height / 2.f;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius = self.bounds.size.height / 2.f;
    self.contentView.layer.cornerRadius = self.bounds.size.height / 2.f;
}

- (void)setIconName:(NSString *)iconName
{
    self.iconView.image = [UIImage imageNamed:iconName];
    [self.iconView sizeToFit];
}

#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(liquidViewWasClicked:)]) {
        [self.delegate liquidViewWasClicked:self];
    }
}

#pragma mark - push / pop

- (void)pushLiquidView:(DYHLiquidView *)view delay:(CGFloat)delay completion:(DYHLiquidViewCompletionBlock)completion
{
    [self pushLiquidView:view delay:delay duration:1.f translationY:self.defaultTranslationY completion:completion];
}

- (void)pushLiquidView:(DYHLiquidView *)view delay:(CGFloat)delay duration:(CGFloat)duration completion:(DYHLiquidViewCompletionBlock)completion
{
    [self pushLiquidView:view delay:delay duration:duration translationY:self.defaultTranslationY completion:completion];
}

- (void)pushLiquidView:(DYHLiquidView *)view delay:(CGFloat)delay duration:(CGFloat)duration translationY:(CGFloat)translationY completion:(DYHLiquidViewCompletionBlock)completion
{
    if (!self.superview || self.pushedView || view.superview || view.bounds.size.width <= 0 || view.bounds.size.height <= 0) {
        //满足计算条件才进行操作
        return;
    }
    
    self.defaultTranslationY = translationY;
    
    [self insertSubview:view belowSubview:self.contentView];
    
    CGPoint selfCenter = [self convertPoint:self.center fromView:self.superview];
    view.center = selfCenter;
    self.pushedView = view;
    
    [self beforeAnimation];
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.65f initialSpringVelocity:0.f options:0 animations:^{
        view.center = CGPointMake(selfCenter.x, selfCenter.y + translationY);
    } completion:^(BOOL finished) {
        if (finished) {
            [self afterAnimation];
            if (completion) {
                completion(self.pushedView);
            }
        }
    }];
}

-(void)popPushedViewWithDelay:(CGFloat)delay completion:(DYHLiquidViewCompletionBlock)completion
{
    if (self.pushedView) {
        CGPoint selfCenter = [self convertPoint:self.center fromView:self.superview];
        [UIView animateWithDuration:0.6f delay:delay usingSpringWithDamping:0.7f initialSpringVelocity:0.f options:0 animations:^{
            self.pushedView.center = selfCenter;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.pushedView removeFromSuperview];
                self.pushedView = nil;
                if (completion) {
                    completion(self);
                }
            }
        }];
    }
}

- (void)popPushedViewWithDelay:(CGFloat)delay
{
    [self popPushedViewWithDelay:delay completion:nil];
}

#pragma mark - 绘制相关

- (void)beforeAnimation
{
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}

- (void)afterAnimation
{
    self.animationCount --;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)displayLinkAction:(CADisplayLink *)displayLink
{
    //NSLog(@"%@",[NSValue valueWithCGPoint:self.pushedView.layer.presentationLayer.position]);
    [self drawLiquidToPushedView:self.pushedView];
}

- (void)drawLiquidToPushedView:(DYHLiquidView *)pushedView
{
    //每一帧刷新时去绘制粘连部分
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint selfCenter = [self convertPoint:self.center fromView:self.superview];
    CGPoint pushedCenter = self.pushedView.layer.presentationLayer.position;
    CGFloat pushingProgress = fabs(selfCenter.y-pushedCenter.y) / fabs(self.defaultTranslationY);
    
    //pushed端的圆
    DYHCircle *pushedCircle = [DYHCircle circleWithCenter:pushedCenter radius:self.pushedView.bounds.size.width/2.f];
    
    //自身端的圆
    DYHCircle *selfCircle = [DYHCircle circleWithCenter:selfCenter radius:(self.pushedView.bounds.size.width/2.f) * MAX(0.7, 1-pushingProgress)];
 
    //画连接部分
    BOOL successDraw = [self drawLiquidFromCircle:selfCircle toCircle:pushedCircle onPath:path];
    
    //刷新cashapeLayer
    if (successDraw) {
        
        if (!self.shapeLayer) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.fillColor = self.contentView.backgroundColor.CGColor;
            [self.layer insertSublayer:shapeLayer atIndex:0];
            self.shapeLayer = shapeLayer;
        }
        
        if (pushingProgress > 0.99) {
            UIBezierPath *finalPath = [UIBezierPath bezierPath];
            [self drawCircle:pushedCircle onPath:finalPath];
            [CATransaction begin];
            self.shapeLayer.path = finalPath.CGPath;
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.3 :0.5 :0.9 :0.5]];
            [CATransaction setCompletionBlock:^{
                self.shapeLayer.hidden = YES;
            }];
            [CATransaction commit];
        } else {
            self.shapeLayer.path = path.CGPath;
            if (self.shapeLayer.hidden) {
                self.shapeLayer.hidden = NO;
            }
        }
        
    } else {
        self.shapeLayer.hidden = YES;
    }
}

- (void)drawCircle:(DYHCircle *)circle onPath:(UIBezierPath *)path
{
    [path moveToPoint:circle.center];
    [path addArcWithCenter:circle.center radius:circle.radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
}

- (BOOL)drawLiquidFromCircle:(DYHCircle *)fromCircle toCircle:(DYHCircle *)toCircle onPath:(UIBezierPath *)path
{
    CGFloat x1 = fromCircle.center.x;
    CGFloat y1 = fromCircle.center.y;
    CGFloat r1 = fromCircle.radius;
    CGFloat x2 = toCircle.center.x;
    CGFloat y2 = toCircle.center.y;
    CGFloat r2 = toCircle.radius;
    
    if (x1 != x2) {
        return NO;
    }
    
    CGPoint pointA = CGPointMake(x1 - r1, y1);
    CGPoint pointB = CGPointMake(x1 + r1, y1);
    CGPoint pointC = CGPointMake(x2 - r2, y2);
    CGPoint pointD = CGPointMake(x2 + r2, y2);
    CGPoint pointC1 = CGPointMake(x1, y1 + (self.defaultTranslationY > 0 ? 1 : -1 )*(fabs(y2 - y1)/2.f));
    
    [path moveToPoint:pointA];
    [path addQuadCurveToPoint:pointC controlPoint:pointC1];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointB controlPoint:pointC1];
    [path addLineToPoint:pointA];
    
    return YES;
}

@end
