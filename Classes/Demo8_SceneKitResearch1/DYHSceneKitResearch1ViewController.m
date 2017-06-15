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
    [self.view addSubview:sceneView];
    self.sceneView = sceneView;
    
    SCNScene *scene = [SCNScene new];
    sceneView.scene = scene;
    
    SCNCamera *camera = [SCNCamera new];
    SCNNode *cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    self.cameraNode = cameraNode;
    
    SCNNode *enviromentLightNode = [SCNNode node];
    enviromentLightNode.light = [SCNLight light];
    enviromentLightNode.light.type = SCNLightTypeAmbient;
    enviromentLightNode.light.color = [UIColor darkGrayColor];
    
    SCNNode *omiLightNode = [SCNNode node];
    omiLightNode.light = [SCNLight light];
    omiLightNode.light.type = SCNLightTypeOmni;
    omiLightNode.light.color = [UIColor redColor];
    omiLightNode.position = SCNVector3Make(-10, 8, 5);
    
    
    SCNNode *geometryNode = [SCNNode nodeWithGeometry:[self.preparedGeometries firstObject]];
    self.geometryNode = geometryNode;
    
    SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:geometryNode];
    constraint.gimbalLockEnabled = YES;
    cameraNode.constraints = @[constraint];
    
    [scene.rootNode addChildNode:cameraNode];
    [scene.rootNode addChildNode:enviromentLightNode];
    [scene.rootNode addChildNode:omiLightNode];
    [scene.rootNode addChildNode:geometryNode];
    
    UISlider *sliderZ = [UISlider new];
    sliderZ.minimumValue = 0.f;
    sliderZ.maximumValue = 10.f;
    sliderZ.tag = 3;
    [sliderZ addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderZ];
    self.sliderZ = sliderZ;
    [sliderZ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSliderLRMargin);
        make.right.mas_equalTo(-kSliderLRMargin);
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UISlider *sliderY = [UISlider new];
    sliderY.minimumValue = 0.f;
    sliderY.maximumValue = 10.f;
    sliderY.tag = 2;
    [sliderY addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderY];
    self.sliderY = sliderY;
    [sliderY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSliderLRMargin);
        make.right.mas_equalTo(-kSliderLRMargin);
        make.bottom.equalTo(sliderZ.mas_top).offset(-kSliderLRMargin);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UISlider *sliderX = [UISlider new];
    sliderX.minimumValue = 0.f;
    sliderX.maximumValue = 10.f;
    sliderX.tag = 1;
    [sliderX addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderX];
    self.sliderX = sliderX;
    [sliderX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSliderLRMargin);
        make.right.mas_equalTo(-kSliderLRMargin);
        make.bottom.equalTo(sliderY.mas_top).offset(-kSliderLRMargin);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    cameraNode.position = SCNVector3Make(0, 0, 0);
    
}

- (NSArray *)preparedGeometries
{
    if (!_preparedGeometries) {
        //SCNSphere SCNCylinder SCNCone SCNTube SCNCapsule SCNTorus SCNText SCNShape
        SCNMaterial *material = [SCNMaterial material];
        material.diffuse.contents = [UIColor redColor];
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
        _preparedGeometries = @[sphere,cylinder,cone,tube,capsule,torus,text];
    }
    return _preparedGeometries;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
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

- (void)slide:(UISlider *)slider
{
    SCNVector3 position = SCNVector3Make(0, 0, 0);
    if (slider.tag == 1) {
        //x
        self.cameraNode.position = SCNVector3Make(slider.value, position.y, position.z);
    } else if(slider.tag == 2) {
        //y
        self.cameraNode.position = SCNVector3Make(position.x, slider.value, position.z);
    } else {
        //z
        self.cameraNode.position = SCNVector3Make(position.x, position.y, slider.value);
    }
}

@end
