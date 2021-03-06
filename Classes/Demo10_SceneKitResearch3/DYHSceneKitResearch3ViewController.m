//
//  DYHSceneKitResearch3ViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/10/11.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHSceneKitResearch3ViewController.h"
#import <SceneKit/SceneKit.h>
#import "DYHSceneKitUtil.h"

@interface DYHSceneKitResearch3ViewController ()

@property (nonatomic, weak) SCNView *sceneView;

@property (nonatomic, weak) SCNNode *cameraNode;

@property (nonatomic, weak) SCNNode *geometryNode;

@property (nonatomic, weak) SCNNode *lightNode;

@property (nonatomic, weak) UISlider *slider;

@end

@implementation DYHSceneKitResearch3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCNView *sceneView = [[SCNView alloc] initWithFrame:self.view.bounds];
    sceneView.backgroundColor = [UIColor blackColor];
    //sceneView.allowsCameraControl = YES;
    [self.view addSubview:sceneView];
    self.sceneView = sceneView;
    
    SCNScene *scene = [SCNScene new];
    sceneView.scene = scene;
    
    SCNCamera *camera = [SCNCamera new];
    SCNNode *cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 10.f);
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
    
    SCNBox *box = [SCNBox boxWithWidth:1.f height:1.f length:1.f chamferRadius:0.f];
    box.firstMaterial.diffuse.contents = [UIColor redColor];
    SCNNode *geometryNode = [SCNNode nodeWithGeometry:box];
    self.geometryNode = geometryNode;
    
    [DYHSceneKitUtil showAxisOnScene:self.sceneView.scene];
    [scene.rootNode addChildNode:cameraNode];
    [scene.rootNode addChildNode:enviromentLightNode];
    [scene.rootNode addChildNode:lightNode];
    [scene.rootNode addChildNode:geometryNode];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(kStandardMargin, self.view.bounds.size.height - kStandardMargin - kStandardMargin, self.view.bounds.size.width - 2*kStandardMargin, kStandardMargin)];
    [slider addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    [sceneView addSubview:slider];
    self.slider = slider;
}

- (void)slide:(UISlider *)s
{
    self.cameraNode.position = SCNVector3Make(-10.f * s.value, 10.f * s.value, 10.f*(1-s.value));
    NSLog(@"position: %@ \n rotation: %@ \n ",[NSValue valueWithSCNVector3:self.cameraNode.position],[NSValue valueWithSCNVector4:self.cameraNode.rotation]);
}

@end
