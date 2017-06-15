//
//  DYHSceneKitResearch1ViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/6/11.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHSceneKitResearch1ViewController.h"
#import <SceneKit/SceneKit.h>

#define kSliderLRMargin 15.f

@interface DYHSceneKitResearch1ViewController ()

@property (nonatomic, weak) SCNView *sceneView;

@property (nonatomic, weak) SCNNode *geometryNode;

@property (nonatomic, weak) SCNNode *cameraNode;

@property (nonatomic, strong) NSArray *preparedGeometries;

@property (nonatomic, weak) UISlider *sliderX;

@property (nonatomic, weak) UISlider *sliderY;

@property (nonatomic, weak) UISlider *sliderZ;

@end

@implementation DYHSceneKitResearch1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCNView *sceneView = [[SCNView alloc] initWithFrame:self.view.bounds];
    sceneView.backgroundColor = [UIColor blackColor];
    sceneView.allowsCameraControl = YES;
    [self.view addSubview:sceneView];
    self.sceneView = sceneView;
    
    SCNScene *scene = [SCNScene new];
    sceneView.scene = scene;
    
    SCNCamera *camera = [SCNCamera new];
    SCNNode *cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 5.f);
    self.cameraNode = cameraNode;
    
    SCNNode *enviromentLightNode = [SCNNode node];
    enviromentLightNode.light = [SCNLight light];
    enviromentLightNode.light.type = SCNLightTypeAmbient;
    enviromentLightNode.light.color = [UIColor darkGrayColor];
    
    SCNNode *omiLightNode = [SCNNode node];
    omiLightNode.light = [SCNLight light];
    omiLightNode.light.type = SCNLightTypeOmni;
    omiLightNode.light.color = [UIColor whiteColor];
    omiLightNode.position = SCNVector3Make(0, 10, 10);
    
    
    SCNNode *geometryNode = [SCNNode nodeWithGeometry:[self.preparedGeometries firstObject]];
    self.geometryNode = geometryNode;
    
    [geometryNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:0 z:1.f duration:1]]];
    
    [scene.rootNode addChildNode:cameraNode];
    [scene.rootNode addChildNode:enviromentLightNode];
    [scene.rootNode addChildNode:omiLightNode];
    [scene.rootNode addChildNode:geometryNode];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:sceneView.gestureRecognizers];
    sceneView.gestureRecognizers = gestureRecognizers;
    
}

- (NSArray *)preparedGeometries
{
    if (!_preparedGeometries) {
        //SCNSphere SCNCylinder SCNCone SCNTube SCNCapsule SCNTorus SCNText SCNShape
        SCNMaterial *material = [SCNMaterial material];
        //material.diffuse.contents = [UIImage imageNamed:@"earth"];
        material.diffuse.contents = [UIColor blueColor];
        SCNBox *box = [SCNBox boxWithWidth:1.f height:1.f length:1.f chamferRadius:0.f];
        box.firstMaterial = material;
        SCNSphere *sphere = [SCNSphere sphereWithRadius:1.f];
        sphere.firstMaterial = material;
        SCNCylinder *cylinder = [SCNCylinder cylinderWithRadius:0.5f height:1.f];
        cylinder.firstMaterial = material;
        SCNCone *cone = [SCNCone coneWithTopRadius:0.5f bottomRadius:1.f height:1.f];
        cone.firstMaterial = material;
        SCNTube *tube = [SCNTube tubeWithInnerRadius:0.5f outerRadius:1.f height:1.f];
        tube.firstMaterial = material;
        SCNCapsule *capsule = [SCNCapsule capsuleWithCapRadius:0.5f height:4.f];
        capsule.firstMaterial = material;
        SCNTorus *torus = [SCNTorus torusWithRingRadius:1.f pipeRadius:0.5f];
        torus.firstMaterial = material;
        SCNText *text = [SCNText textWithString:@"Hello 世界" extrusionDepth:2.f];
        text.font = [UIFont systemFontOfSize:1.f];
        text.firstMaterial = material;
        _preparedGeometries = @[box,sphere,cylinder,cone,tube,capsule,torus,text];
    }
    return _preparedGeometries;
}

- (void)handleTap:(id)sender
{
    NSInteger nowIndex = [self.preparedGeometries indexOfObject:self.geometryNode.geometry];
    SCNGeometry *target;
    if (nowIndex + 1 < self.preparedGeometries.count ) {
        target = self.preparedGeometries[nowIndex + 1];
    } else {
        target = [self.preparedGeometries firstObject];
    }
    
   self.geometryNode.geometry = target;
    
}

@end
