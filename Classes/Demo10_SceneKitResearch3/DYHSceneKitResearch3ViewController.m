//
//  DYHSceneKitResearch3ViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/10/11.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHSceneKitResearch3ViewController.h"
#import <SceneKit/SceneKit.h>

@interface DYHSceneKitResearch3ViewController ()

@property (nonatomic, weak) SCNView *sceneView;

@property (nonatomic, weak) SCNNode *geometryNode;

@property (nonatomic, weak) SCNNode *lightNode;

@property (nonatomic, strong) NSArray *preparedGeometries;

@property (nonatomic, strong) NSArray *preparedLightType;

@end

@implementation DYHSceneKitResearch3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCNView *sceneView = [[SCNView alloc] initWithFrame:self.view.bounds];
    sceneView.allowsCameraControl = YES;
    sceneView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sceneView];
    self.sceneView = sceneView;
    
    SCNScene *scene = [SCNScene new];
    sceneView.scene = scene;
    
    SCNCamera *camera = [SCNCamera new];
    SCNNode *cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0.f, 0.f, 10.f);
    
    SCNNode *enviromentLightNode = [SCNNode node];
    enviromentLightNode.light = [SCNLight light];
    enviromentLightNode.light.type = SCNLightTypeAmbient;
    enviromentLightNode.light.color = [UIColor darkGrayColor];
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = [self.preparedLightType firstObject];
    lightNode.light.color = [UIColor yellowColor];
    lightNode.position = SCNVector3Make(0, 10.f, 5.f);
    self.lightNode = lightNode;
    
    SCNNode *geometryNode = [SCNNode nodeWithGeometry:[self.preparedGeometries objectAtIndex:1]];
    self.geometryNode = geometryNode;
    
    [scene.rootNode addChildNode:cameraNode];
    [scene.rootNode addChildNode:enviromentLightNode];
    [scene.rootNode addChildNode:lightNode];
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
        material.diffuse.contents = [UIColor redColor];
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
        SCNText *text = [SCNText textWithString:@"Hello" extrusionDepth:2.f];
        text.font = [UIFont systemFontOfSize:1.f];
        text.firstMaterial = material;
        _preparedGeometries = @[box,sphere,cylinder,cone,tube,capsule,torus,text];
    }
    return _preparedGeometries;
}

- (NSArray *)preparedLightType
{
    if (!_preparedLightType) {
        _preparedLightType = @[SCNLightTypeOmni,SCNLightTypeSpot,SCNLightTypeDirectional];
    }
    return _preparedLightType;
}

- (void)handleTap:(id)sender
{
    NSInteger nowIndex = [self.preparedLightType indexOfObject:self.lightNode.light.type];
    if (nowIndex + 1 < self.preparedLightType.count ) {
        self.lightNode.light.type = self.preparedLightType[nowIndex + 1];
    } else {
        self.lightNode.light.type = [self.preparedLightType firstObject];
    }
    
}

@end
