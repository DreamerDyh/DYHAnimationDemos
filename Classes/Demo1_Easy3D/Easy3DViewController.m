//
//  Easy3DViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/21.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "Easy3DViewController.h"

#define kTopGuideHeight 64.f
#define kCenterLayerWH 200.f
#define kExtraMargin 15.f
#define kButtonInnerMargin 5.f
#define kExtraMarginLarge 35.f
#define kButtonColor RGBCOLOR(242, 57, 103)
#define kLayerColor RGBCOLOR(15, 182, 242)

typedef NS_ENUM(NSInteger, buttonTag) {
    buttonTagX = 0,
    buttonTagY,
    buttonTagZ
};

@interface Easy3DViewController ()<CAAnimationDelegate>

@property (nonatomic, weak) CALayer *centerLayer;

@property (nonatomic, weak) UISwitch *m34Switch;

@property (nonatomic, weak) UILabel *m34TipLabel;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, weak) UILabel *isAnimaTingTipLabel;

@property (nonatomic, assign) BOOL isAnimating; //是否正在执行动画

@property (nonatomic, assign) BOOL isPerspective; //是否开启透视

@end

@implementation Easy3DViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self setUpDatas];
}

#pragma mark - SETTER / GETTER
- (void)setIsPerspective:(BOOL)isPerspective
{
    _isPerspective = isPerspective;
    self.m34TipLabel.text = isPerspective ? @"透视开启中" : @"透视已关闭";
}

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

#pragma mark - subViews

- (void)setUpSubViews
{
    [self setUpNav];
    
    //中间的Label
    CALayer *centerLayer = [CALayer new];
    centerLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"whiteBear"].CGImage);
    centerLayer.frame = CGRectMake((SCREEN_WIDTH - kCenterLayerWH)/2, (SCREEN_HEIGHT - kCenterLayerWH)/2, kCenterLayerWH, kCenterLayerWH);
    centerLayer.backgroundColor = kLayerColor.CGColor;
    centerLayer.shadowPath = [UIBezierPath bezierPathWithRect:centerLayer.bounds].CGPath;
    centerLayer.shadowOpacity = 0.5f;
    centerLayer.shadowOffset = CGSizeMake(0, 5);
    [self.view.layer addSublayer:centerLayer];
    self.centerLayer = centerLayer;
    
    //m34开关
    UISwitch *m34Switch = [UISwitch new];
    [m34Switch addTarget:self action:@selector(m34SwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:m34Switch];
    self.m34Switch = m34Switch;
    
    [m34Switch sizeToFit];
    [m34Switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(3.5 * kExtraMargin);
        make.top.equalTo(self.view.mas_top).offset(2 * kTopGuideHeight);
    }];
    
    //m34开关旁的提示Label
    UILabel *m34tipLabel = [UILabel new];
    m34tipLabel.font = SYSFONT(15.f);
    [self.view addSubview:m34tipLabel];
    self.m34TipLabel = m34tipLabel;
    
    [m34tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(m34Switch.mas_centerY);
        make.right.equalTo(m34Switch.mas_left).offset(-kExtraMargin);
    }];
    
    //动画状态提示Label
    UILabel *isAnimaTingTipLabel = [UILabel new];
    isAnimaTingTipLabel.font = SYSFONT(15.f);
    isAnimaTingTipLabel.textColor = kLayerColor;
    [self.view addSubview:isAnimaTingTipLabel];
    self.isAnimaTingTipLabel = isAnimaTingTipLabel;
    
    [isAnimaTingTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(m34tipLabel.mas_top).offset(-kExtraMargin-5.f);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    //执行动画的buttons
    [self addActiveButtonWithTitle:@"点击绕X轴旋转" tag:buttonTagX];
    [self addActiveButtonWithTitle:@"点击绕Y轴旋转" tag:buttonTagY];
    [self addActiveButtonWithTitle:@"点击绕Z轴旋转" tag:buttonTagZ];
}

- (void)setUpDatas
{
    //强制初始化一次isPerspective，给m34tipLabel赋值
    self.isPerspective = NO;
    self.isAnimating = NO;
}

- (void)setUpNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Easy3DTransform";
}

- (void)addActiveButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    //配置button
    UIButton *activeButton = [UIButton new];
    activeButton.layer.cornerRadius = kButtonInnerMargin;
    activeButton.layer.borderColor = kButtonColor.CGColor;
    activeButton.layer.borderWidth = 1.f;
    [activeButton setTitle:title forState:UIControlStateNormal];
    [activeButton setTitleColor:kButtonColor forState:UIControlStateNormal];
    [activeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    activeButton.contentEdgeInsets = UIEdgeInsetsMake(kButtonInnerMargin, kButtonInnerMargin, kButtonInnerMargin, kButtonInnerMargin);
    activeButton.titleLabel.font = SYSFONT(14.f);
    [activeButton addTarget:self action:@selector(active:) forControlEvents:UIControlEventTouchUpInside];
    activeButton.tag = tag;
    
    [self.view addSubview:activeButton];
    [self.buttons addObject:activeButton];
    
    //位置与size
    [activeButton sizeToFit];
    [activeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.m34Switch.mas_bottom).offset(kCenterLayerWH + 3*kExtraMargin + tag*kExtraMarginLarge);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}

#pragma mark - 回调

- (void)m34SwitchValueChanged:(UISwitch *)sender
{
    self.isPerspective = sender.on;
}

- (void)active:(UIButton *)sender
{
    if (self.isAnimating) {
        //不重复执行动画
        return;
    }
    
    CGFloat xFactor,yFactor,zFactor = 0;
    switch (sender.tag) {
        case buttonTagX:
            xFactor = 1.f;
            break;
        case buttonTagY:
            yFactor = 1.f;
            break;
        case buttonTagZ:
            zFactor = 1.f;
            break;
        default:
            break;
    }
    
    self.isAnimating = YES;
    
    //配置目标transform
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI_4, xFactor, yFactor, zFactor);
    if (self.isPerspective) {
        //通过配置m34 开启透视
        transform.m34 = - 1.0 / 500.0;
    }
    //添加动画
    CABasicAnimation* transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.delegate = self;
    transformAnimation.duration = 2.f;
    transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.centerLayer addAnimation:transformAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.isAnimating = NO;
    }
}

@end
