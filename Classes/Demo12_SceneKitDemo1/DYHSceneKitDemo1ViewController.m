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

@interface DYHSceneKitDemo1ViewController ()

@property (nonatomic, weak) UIImageView *bgView;

@property (nonatomic, weak) SCNView *sceneView;

@property (nonatomic, weak) SCNNode *earthNode;

@property (nonatomic, weak) SCNNode *cameraNode;

@end

@implementation DYHSceneKitDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
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
    
}

- (void)setUpBasicNodes:(SCNScene *)scene
{
    SCNCamera *camera = [SCNCamera new];
    SCNNode *cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 5.f, 15.f);
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
     ltLightNode.position = SCNVector3Make(-10.f, 10.f, 10.f);
    
    
    [scene.rootNode addChildNode:cameraNode];
    [scene.rootNode addChildNode:enviromentLightNode];
    [scene.rootNode addChildNode:ltLightNode];
}

- (void)setUpEarth:(SCNScene *)scene
{
    SCNSphere *sphere = [SCNSphere sphereWithRadius:5.f];
    SCNNode *earthNode = [SCNNode nodeWithGeometry:sphere];
    sphere.firstMaterial.diffuse.contents = [UIImage imageNamed:@"earthDiffuse"];
    sphere.firstMaterial.specular.contents = [UIImage imageNamed:@"earthSpecular"];
    sphere.firstMaterial.normal.contents = [UIImage imageNamed:@"earthNormal"];
    self.earthNode = earthNode;
    
    [self.earthNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0.f y:1.f z:0.f duration:5.f]]];
    
    [scene.rootNode addChildNode:earthNode];
}

@end
