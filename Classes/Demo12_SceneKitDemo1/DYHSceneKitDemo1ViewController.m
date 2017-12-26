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

@interface DYHSceneKitDemo1ViewController ()

@property (nonatomic, weak) UIImageView *bgView;

@property (nonatomic, weak) SCNView *sceneView;

@property (nonatomic, weak) SCNNode *earthNode;

@property (nonatomic, weak) SCNNode *cameraNode;

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
    self.cityLabel.alpha = 0.f;
    self.cityLabel.text = [self cityDescStrWithCityDic:city];
    [UIView animateWithDuration:0.5f animations:^{
        self.cityLabel.alpha = 1.f;
    }];
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
    cityLabel.font = [UIFont systemFontOfSize:45.f weight:UIFontWeightThin];
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
}

#pragma mark - Tool

- (NSString *)cityDescStrWithCityDic:(NSDictionary *)cityDic
{
    if (!cityDic) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@ (%.0f,%.0f)",[cityDic objectForKey:kCityKeyName],[[cityDic objectForKey:kCityKeyLatitude] doubleValue],[[cityDic objectForKey:kCityKeyLongitude] doubleValue]];
}

@end
