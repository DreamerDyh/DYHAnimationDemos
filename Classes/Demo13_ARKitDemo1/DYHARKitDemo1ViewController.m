//
//  DYHARKitDemo1ViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/27.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHARKitDemo1ViewController.h"
#import "DYHSceneKitUtil.h"
#import <SceneKit/SceneKit.h>
#import "DYHLocationManager.h"

#define kEarthRadius 0.05f
#define kCityLabelTopInset 55.f
#define kTagRadius 0.001f


#define RADIANS_TO_DEGREES(radian) \
((radian) * (180.0 / M_PI))

#define DEGREES_TO_RADIANS(angle) \
((angle) / 180.0 * M_PI)

@interface DYHARKitDemo1ViewController ()

@property (nonatomic, weak) SCNNode *earthNode;

@property (nonatomic, weak) SCNNode *tagNode;

@property (nonatomic, weak) UILabel *cityLabel;

@property (nonatomic, strong) NSDictionary *city;

@end

@implementation DYHARKitDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    [self setUpObservers];
    [[DYHLocationManager sharedManager] locateCity];
}

#pragma mark - Notification

- (void)setUpObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locateCitySucc:) name:klocateCitySuccessNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)locateCitySucc:(NSNotification *)nofity
{
    if (nofity.object && [nofity.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *city = (NSDictionary *)nofity.object;
        self.city = city;
    }
}

#pragma mark - Set/ Ger

- (void)setCity:(NSDictionary *)city
{
    _city = city;
    [self.cityLabel.layer removeAllAnimations];
    self.cityLabel.alpha = 0.f;
    self.cityLabel.text = [self cityDescStrWithCityDic:city];
    [UIView animateWithDuration:0.5f animations:^{
        self.cityLabel.alpha = 1.f;
    }];
    [self adjustTagWithLatitude:[[city objectForKey:kCityKeyLatitude] doubleValue] longitude:[[city objectForKey:kCityKeyLongitude] doubleValue]];
}

#pragma mark - SubViews

- (void)setUpSubviews
{
    [self setUpBasicNodes:self.sceneView.scene];
    [self setUpEarth:self.sceneView.scene];
    
    //CityLabel
    UILabel *cityLabel = [UILabel new];
    cityLabel.font = [UIFont systemFontOfSize:38.f weight:UIFontWeightUltraLight];
    cityLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:cityLabel];
    self.cityLabel = cityLabel;
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kCityLabelTopInset);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    //手势识别
    //拖动
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.sceneView addGestureRecognizer:panRecog];
    
}

- (void)setUpBasicNodes:(SCNScene *)scene
{
    //环境光
    SCNNode *enviromentLightNode = [SCNNode node];
    enviromentLightNode.light = [SCNLight light];
    enviromentLightNode.light.type = SCNLightTypeAmbient;
    enviromentLightNode.light.color = [UIColor colorWithWhite:0.4 alpha:1];
    
    //左上角打灯
    SCNNode *ltLightNode = [SCNNode node];
    ltLightNode.light = [SCNLight light];
    ltLightNode.light.type = SCNLightTypeOmni;
    ltLightNode.light.color = [UIColor whiteColor];
    ltLightNode.position = SCNVector3Make(-(2*kEarthRadius), 2*kEarthRadius, 2*kEarthRadius);
    
    [scene.rootNode addChildNode:enviromentLightNode];
    [scene.rootNode addChildNode:ltLightNode];
}

- (void)setUpEarth:(SCNScene *)scene
{
    SCNSphere *sphere = [SCNSphere sphereWithRadius:kEarthRadius];
    SCNNode *earthNode = [SCNNode nodeWithGeometry:sphere];
    sphere.firstMaterial.diffuse.contents = [UIImage imageNamed:@"earthDiffuse"];
    sphere.firstMaterial.specular.contents = [UIImage imageNamed:@"earthSpecular"];
    sphere.firstMaterial.normal.contents = [UIImage imageNamed:@"earthNormal"];
    self.earthNode = earthNode;
    
    [self letEarthRun:YES];;
    
    [scene.rootNode addChildNode:earthNode];
    
    SCNSphere *sphere2 = [SCNSphere sphereWithRadius:kTagRadius];
    sphere2.firstMaterial.diffuse.contents = [UIColor clearColor];
    SCNNode *tagNode = [SCNNode nodeWithGeometry:sphere2];
    tagNode.hidden = YES;
    [tagNode addParticleSystem:[self fitPraticleSystem]];
    
    [self.earthNode addChildNode:tagNode];
    self.tagNode = tagNode;
}

#pragma mark - 手势处理

- (void)pan:(UIPanGestureRecognizer *)panRecog
{
    if (panRecog.state == UIGestureRecognizerStateBegan) {
        //终止自转
        [self letEarthRun:NO];
    } else if (panRecog.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panRecog translationInView:self.sceneView];
        CGFloat fakeDegree = (translation.x) * 0.1;
        if (fakeDegree > 15) {
            fakeDegree = 15;
        }
        self.earthNode.rotation = SCNVector4Make(0.f, 1.f, 0.f, self.earthNode.rotation.w + DEGREES_TO_RADIANS(fakeDegree));
    } else if (panRecog.state == UIGestureRecognizerStateEnded || panRecog.state == UIGestureRecognizerStateCancelled)
    {
        //取消或者终止 重启自转
        [self letEarthRun:YES];
    }
}

#pragma mark - Tool

- (NSString *)cityDescStrWithCityDic:(NSDictionary *)cityDic
{
    if (!cityDic) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@ (%.0f,%.0f)",[cityDic objectForKey:kCityKeyName],[[cityDic objectForKey:kCityKeyLatitude] doubleValue],[[cityDic objectForKey:kCityKeyLongitude] doubleValue]];
}

- (void)adjustTagWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    self.tagNode.hidden = NO;
    
    SCNVector3 position = [self vectorWithLatitude:latitude longitude:longitude radius:kEarthRadius + kTagRadius];
    self.tagNode.position = position;
    
}

- (SCNVector3)vectorWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude radius:(CGFloat)radius
{
    //经纬度转坐标
    //经度
    CGFloat lg = DEGREES_TO_RADIANS(longitude);
    //纬度
    CGFloat lt = DEGREES_TO_RADIANS(latitude);
    CGFloat largerR = radius;
    CGFloat y = largerR * sin(lt);
    CGFloat temp = largerR * cos(lt);
    CGFloat x = temp * sin(lg);
    CGFloat z = temp * cos(lg);
    
    return SCNVector3Make(x, y, z);
}

- (void)letEarthRun:(BOOL)run
{
    if (run) {
        [self.earthNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0.f y:1.f z:0.f duration:2.f]]];
    } else {
        [self.earthNode removeAllActions];
    }
}

- (SCNParticleSystem *)fitPraticleSystem
{
    //粒子
    SCNParticleSystem *particles = [SCNParticleSystem new];
    //循环发射
    particles.loops = YES;
    particles.particleLifeSpan = 1.f;
    particles.birthRate = 50.f;
    particles.emissionDuration = 2.f;
    particles.spreadingAngle = 10;
    particles.particleDiesOnCollision = YES;
    particles.particleLifeSpanVariation = 0.3f;
    particles.particleVelocity = 1.5 * 0.01f;
    particles.particleLifeSpanVariation = 3.f;
    particles.particleSize = 0.001f;
    particles.stretchFactor = 0.05f;
    particles.particleImage = [UIImage imageNamed:@"particle"];
    
    return particles;
}

@end
