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

@property (nonatomic, weak) SCNView *sceneView;

@property (nonatomic, weak) SCNNode *earthNode;

@property (nonatomic, weak) SCNNode *cameraNode;

@property (nonatomic, weak) SCNNode *lightNode;

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
    
    //
    SCNView *sceneView = [SCNView new];
    sceneView.scene = [SCNScene new];
    sceneView.backgroundColor = [UIColor redColor];
    [self.view addSubview:sceneView];
    self.sceneView = sceneView;
    
    [sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)));
    }];
    
    SCNCamera *camera = [SCNCamera new];
    SCNNode *cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 5.f);
    self.cameraNode = cameraNode;
    
    SCNNode *enviromentLightNode = [SCNNode node];
    enviromentLightNode.light = [SCNLight light];
    enviromentLightNode.light.type = SCNLightTypeAmbient;
    enviromentLightNode.light.color = [UIColor darkGrayColor];
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.light.color = [UIColor yellowColor];
    lightNode.position = SCNVector3Make(0, 10.f, 5.f);
    self.lightNode = lightNode;
    
    [sceneView.scene.rootNode addChildNode:cameraNode];
    [sceneView.scene.rootNode addChildNode:enviromentLightNode];
    [sceneView.scene.rootNode addChildNode:lightNode];
    [DYHSceneKitUtil showAxisOnScene:sceneView.scene];
}

@end
