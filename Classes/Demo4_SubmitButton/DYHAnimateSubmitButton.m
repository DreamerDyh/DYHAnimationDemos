//
//  DYHAnimateSubmitButton.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/4/1.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHAnimateSubmitButton.h"

#define kBorderWidth 2.f
#define kAnimationName @"kAnimationName"
#define kAnimationNameProgress @"kAnimationNameProgress"

@interface DYHAnimateSubmitButton()<CAAnimationDelegate>

@property (nonatomic, assign) CGRect originalBounds;

@property (nonatomic, weak) CAShapeLayer *progressShapeLayer;

@property (nonatomic, weak) CAShapeLayer *progressBackLayer;

@property (nonatomic, weak) UIImageView *finishIconImageView;

@property (nonatomic, assign) BOOL isNotFirstSet;

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation DYHAnimateSubmitButton

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpStyles];
    }
    return self;
}


#pragma mark - Setter/ Getter

- (void)setUpStyles
{
    self.layer.borderColor = DYHAnimateSubmitButtonColor.CGColor;
    self.layer.borderWidth = kBorderWidth;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    if (!self.isNotFirstSet) {
        self.layer.cornerRadius = self.bounds.size.height/2.f;
        self.originalBounds = self.bounds;
        self.isNotFirstSet = YES;
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = DYHAnimateSubmitButtonColor;
        titleLabel.font = SYSFONT(19.f);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (CAShapeLayer *)progressShapeLayer
{
    if (!_progressShapeLayer) {
        CAShapeLayer *progressLayer = [self styledLayerWithBorderColor:DYHAnimateSubmitButtonColor];
        [self.layer addSublayer:progressLayer];
        _progressShapeLayer = progressLayer;
    }
    return _progressShapeLayer;
}

- (CAShapeLayer *)progressBackLayer
{
    if (!_progressBackLayer) {
        CAShapeLayer *progressBackLayer = [self styledLayerWithBorderColor:DYHAnimateSubmitButtonGrayColor];
        [self.layer addSublayer:progressBackLayer];
        _progressBackLayer = progressBackLayer;
    }
    return _progressBackLayer;
}

- (CAShapeLayer *)styledLayerWithBorderColor:(UIColor *)borderColor
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.opacity = 0.f;
    layer.lineWidth = 2*kBorderWidth;
    layer.strokeColor = borderColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
}

- (UIBezierPath *)fitProgressPath
{
    CGPoint selfCenter = [self convertPoint:self.center fromView:self.superview];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:selfCenter radius:(self.bounds.size.height-kBorderWidth)/2.f startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:YES];
    return path;
}

- (UIImageView *)finishIconImageView
{
    if (!_finishIconImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submitFinished"]];
        imageView.alpha = 0.f;
        [self addSubview:imageView];
        _finishIconImageView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
    }
    return _finishIconImageView;
}

#pragma mark - animations

- (void)doAnimationCompletion:(DYHAnimateSubmitButtonCompletion)completion
{
    if (self.isAnimating) {
        return;
    }
    
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.titleLabel.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.f options:0 animations:^{
                self.bounds = CGRectMake(0, 0, self.originalBounds.size.height, self.originalBounds.size.height);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self doProgressAnimation];
                }
            }];

        }
    }];
}

- (void)doProgressAnimation
{
    //borderWidth置0(动画过渡)
    self.layer.borderWidth = 0.f;
    [self.layer addAnimation:[self borderWidthAnimationFrom:kBorderWidth] forKey:nil];
    
    UIBezierPath *fitPath = [self fitProgressPath];
    self.progressBackLayer.path = fitPath.CGPath;
    self.progressShapeLayer.path = fitPath.CGPath;
    
    //progressBackLayer出现 (动画过渡)
    self.progressBackLayer.opacity = 1.f;
    [self.progressBackLayer addAnimation:[self opacityAnimationFrom:0] forKey:nil];
    
    //progressBar出现并立即开始转动
    self.progressShapeLayer.opacity = 1.f;
    CABasicAnimation* progressAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAnimation.delegate = self;
    progressAnimation.duration = 2.f;
    progressAnimation.fromValue = @(0);
    progressAnimation.toValue = @(1);
    progressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [progressAnimation setValue:kAnimationNameProgress forKey:kAnimationName];
    [self.progressShapeLayer addAnimation:progressAnimation forKey:nil];
}

/*
 * 返回一个opacity动画
 */
- (CABasicAnimation *)opacityAnimationFrom:(CGFloat)from
{
    CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(from);
    opacityAnimation.duration = 0.2f;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return opacityAnimation;
}

/*
 * 返回一个borderWidth动画
 */
- (CABasicAnimation *)borderWidthAnimationFrom:(CGFloat)from
{
    CABasicAnimation* borderWidthAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    borderWidthAnimation.duration = 0.2f;
    borderWidthAnimation.fromValue = @(from);
    borderWidthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return borderWidthAnimation;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag && [[anim valueForKey:kAnimationName] isEqualToString:kAnimationNameProgress]) {
        //progress执行完成
        
        //干掉progressBack和shape
        self.progressBackLayer.opacity = 0.f;
        self.progressShapeLayer.opacity = 0.f;
        
        //恢复borderWidth
        self.layer.borderWidth = kBorderWidth;
        
        //设置backgroundColor
        self.backgroundColor = DYHAnimateSubmitButtonColor;
        
        //显示勾勾的同时恢复形状
        [UIView animateWithDuration:0.4f delay:0.1f usingSpringWithDamping:0.7f initialSpringVelocity:0.f options:0 animations:^{
            self.bounds = self.originalBounds;
        } completion:nil];
        
        [UIView animateWithDuration:0.7f animations:^{
            self.finishIconImageView.alpha = 1.f;
        } completion:^(BOOL finished) {
            if (finished) {
                //恢复label
                self.titleLabel.alpha = 1.f;
                [UIView animateWithDuration:0.3f animations:^{
                    self.backgroundColor = [UIColor clearColor];
                    self.finishIconImageView.alpha = 0.f;
                } completion:^(BOOL finished) {
                    self.isAnimating = NO;
                }];
                
            }
        }];
    }
}

#pragma mark - 回调
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(animateSubmitButtonWasClicked:)]) {
        [self.delegate animateSubmitButtonWasClicked:self];
    }
}



@end
