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
    buttonTagX = 1,
    buttonTagY,
    buttonTagZ,
    buttonTagReback
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
    
    //配置是否需要透视
    if (isPerspective) {
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = - 1.f / 200.f;
        self.view.layer.sublayerTransform = perspective;
    } else {
        self.view.layer.sublayerTransform = CATransform3DIdentity;
    }
    self.m34TipLabel.text = isPerspective ? @"透视开启中" : @"透视已关闭";
    self.centerLayer.transform = CATransform3DIdentity;
}

- (void)setIsAnimating:(BOOL)isAnimating
{
    _isAnimating = isAnimating;
    self.isAnimaTingTipLabel.text = isAnimating ? @"⭕️正在执行动画..." : @"⚠️动画执行结束";
    if (isAnimating) {
        self.m34Switch.enabled = NO;
        for (UIButton *button in self.buttons) {
            button.enabled = NO;
        }
    } else {
        self.m34Switch.enabled = YES;
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
    centerLayer.borderColor = [UIColor blackColor].CGColor;
    centerLayer.borderWidth = 2.f;
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
        make.top.equalTo(self.view.mas_top).offset(self.centerLayer.frame.origin.y - 3*kExtraMargin);
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
        make.bottom.equalTo(m34tipLabel.mas_top).offset(-kExtraMargin);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    //执行动画的buttons
    [self addActiveButtonWithTitle:@"点击绕X轴旋转" tag:buttonTagX];
    [self addActiveButtonWithTitle:@"点击绕Y轴旋转" tag:buttonTagY];
    [self addActiveButtonWithTitle:@"点击绕Z轴旋转" tag:buttonTagZ];
    [self addActiveButtonWithTitle:@"复位" tag:buttonTagReback];
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
        make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(self.centerLayer.frame)+kExtraMargin+(tag - 1)*kExtraMarginLarge);
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
    self.isAnimating = YES;
    
    //配置目标transform
    CATransform3D transform;
    
    if (sender.tag == buttonTagReback) {
        //复位
        transform = CATransform3DIdentity;
    } else {
        //旋转
        CGFloat xFactor = 0,yFactor = 0,zFactor = 0;
        //根据tag，判断绕哪根轴旋转
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
        
        transform = CATransform3DConcat(CATransform3DIdentity, self.centerLayer.transform);
        transform = CATransform3DRotate(transform, M_PI / 4, xFactor, yFactor, zFactor);
    }
    
    //添加动画
    self.centerLayer.transform = transform;
    CABasicAnimation* transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.delegate = self;
    transformAnimation.duration = 0.4f;
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
