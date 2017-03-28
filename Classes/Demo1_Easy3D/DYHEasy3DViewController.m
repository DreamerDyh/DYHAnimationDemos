//
//  Easy3DViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/21.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHEasy3DViewController.h"
#import "DYHActiveButton.h"

#define kCenterLayerWH 200.f
#define kExtraMargin 15.f
#define kExtraMarginLarge 35.f
#define kLayerColor RGBCOLOR(15, 182, 242)

typedef NS_ENUM(NSInteger, buttonTag) {
    buttonTagX = 1,
    buttonTagY,
    buttonTagZ,
    buttonTagReback
};

@interface DYHEasy3DViewController ()<CAAnimationDelegate>

@property (nonatomic, weak) CALayer *centerLayer;

@property (nonatomic, weak) UISwitch *m34Switch;

@property (nonatomic, weak) UILabel *m34TipLabel;

@property (nonatomic, assign) BOOL isPerspective; //是否开启透视

@end

@implementation DYHEasy3DViewController

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
    [super setIsAnimating:isAnimating];
    
    if (isAnimating) {
        self.m34Switch.enabled = NO;
    } else {
        self.m34Switch.enabled = YES;
    }
}



#pragma mark - subViews

- (void)setUpSubViews
{
    [self setUpNav];
    
    //中间的Label
    CALayer *centerLayer = [CALayer new];
    centerLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"whiteBear"].CGImage);
    centerLayer.frame = CGRectMake((SCREEN_WIDTH - kCenterLayerWH)/2, (SCREEN_HEIGHT - kCenterLayerWH)/2, kCenterLayerWH, kCenterLayerWH);
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
    
    //执行动画的buttons
    [self addActiveButtonWithTitle:@"绕X轴旋转PI/4" tag:buttonTagX];
    [self addActiveButtonWithTitle:@"绕Y轴旋转PI/4" tag:buttonTagY];
    [self addActiveButtonWithTitle:@"绕Z轴旋转PI/4" tag:buttonTagZ];
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
    self.navigationItem.title = @"Easy3DTransform";
}

- (void)addActiveButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    //配置button
    DYHActiveButton *activeButton = [DYHActiveButton new];
    [activeButton setTitle:title forState:UIControlStateNormal];
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
