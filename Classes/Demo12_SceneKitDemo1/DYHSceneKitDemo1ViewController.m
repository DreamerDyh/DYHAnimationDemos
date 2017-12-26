//
//  DYHSceneKitDemo1ViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/25.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHSceneKitDemo1ViewController.h"
#import "DYHSceneKitUtil.h"
#import <SceneKit/SceneKit.h>
#import "DYHLocationManager.h"

#define kEarthRadius 5.f
#define kCityLabelTopInset 15.f
#define kTagRadius 0.1f


#define RADIANS_TO_DEGREES(radian) \
((radian) * (180.0 / M_PI))

#define DEGREES_TO_RADIANS(angle) \
((angle) / 180.0 * M_PI)

@interface DYHSceneKitDemo1ViewController ()

@property (nonatomic, weak) UIImageView *bgView;

@property (nonatomic, weak) SCNView *sceneView;

@property (nonatomic, weak) SCNNode *earthNode;

@property (nonatomic, weak) SCNNode *cameraNode;

@property (nonatomic, weak) SCNNode *tagNode;

@property (nonatomic, weak) UILabel *cityLabel;

@property (nonatomic, strong) NSDictionary *city;

@end

@implementation DYHSceneKitDemo1ViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"earthBg"]];
    [self.view addSubview:imageView];
    self.bgView = imageView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //sceneView
    SCNView *sceneView = [SCNView new];
    sceneView.scene = [SCNScene new];
    sceneView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sceneView];
    self.sceneView = sceneView;
    
    [sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)));
    }];
    
    [self setUpBasicNodes:sceneView.scene];
    [self setUpEarth:sceneView.scene];
    
    //CityLabel
    
    UILabel *cityLabel = [UILabel new];
    cityLabel.font = [UIFont systemFontOfSize:38.f weight:UIFontWeightUltraLight];
    cityLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:cityLabel];
    self.cityLabel = cityLabel;
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sceneView.mas_bottom).offset(kCityLabelTopInset);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}

- (void)setUpBasicNodes:(SCNScene *)scene
{
    SCNCamera *camera = [SCNCamera new];
    SCNNode *cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, kEarthRadius, 3*kEarthRadius);
    cameraNode.rotation = SCNVector4Make(1.f, 0.f, 0.f, -M_PI/10.f);
    self.cameraNode = cameraNode;
    
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
    
    [scene.rootNode addChildNode:cameraNode];
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
    
    [self.earthNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0.f y:1.f z:0.f duration:5.f]]];
    
    [scene.rootNode addChildNode:earthNode];
    
    SCNSphere *sphere2 = [SCNSphere sphereWithRadius:kTagRadius];
    sphere2.firstMaterial.diffuse.contents = RGBCOLOR(255, 81, 47);
    SCNNode *tagNode = [SCNNode nodeWithGeometry:sphere2];
    tagNode.hidden = YES;
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
    particles.particleVelocity = 1.5f;
    particles.particleLifeSpanVariation = 3.f;
    particles.particleSize = 0.1f;
    particles.stretchFactor = 0.05f;
    particles.particleImage = [UIImage imageNamed:@"particle"];
    [tagNode addParticleSystem:particles];
    
    [self.earthNode addChildNode:tagNode];
    self.tagNode = tagNode;
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
    
    self.tagNode.position = [self vectorWithLatitude:latitude longitude:longitude radius:kEarthRadius + kTagRadius];
    
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

@end
