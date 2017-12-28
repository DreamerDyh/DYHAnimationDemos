//
//  DYHARKitDemo2ViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHARKitDemo2ViewController.h"
#import "DYHBoxRoomNode.h"

@interface DYHARKitDemo2ViewController ()<ARSCNViewDelegate>

@property (nonatomic, weak) SCNNode *roomNode;

@end

@implementation DYHARKitDemo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

- (void)setUpSubviews
{
    self.sceneView.debugOptions = ARSCNDebugOptionShowWorldOrigin;
    self.sceneView.delegate = self;
    
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSceneView:)];
    [self.sceneView addGestureRecognizer:tapRecog];
}

#pragma mark - ARSCNViewDelegate

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if (![anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        return;
    }
    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
    SCNPlane *plane = [SCNPlane planeWithWidth:planeAnchor.extent.x height:planeAnchor.extent.z];
    plane.firstMaterial.diffuse.contents = [UIImage imageNamed:@"grid"];
    SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
    planeNode.simdPosition = simd_make_float3(planeAnchor.center.x, 0, planeAnchor.center.z);
    planeNode.transform = SCNMatrix4MakeRotation(-M_PI_2, 1, 0, 0);
    [node addChildNode:planeNode];
    
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if (!([anchor isMemberOfClass:[ARPlaneAnchor class]] && [node.childNodes.firstObject.geometry isMemberOfClass:[SCNPlane class]])) {
        return;
    }
    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
    SCNNode *planeNode = node.childNodes.firstObject;
    SCNPlane *plane = (SCNPlane *)planeNode.geometry;
    
    planeNode.simdPosition = simd_make_float3(planeAnchor.center.x, 0, planeAnchor.center.z);
    plane.width = planeAnchor.extent.x;
    plane.height = planeAnchor.extent.z;
    
}

#pragma mark - Tap

- (void)didTapSceneView:(UITapGestureRecognizer *)recog
{
    CGPoint tapPoint = [recog locationInView:self.sceneView];
    NSArray *results = [self.sceneView hitTest:tapPoint types:ARHitTestResultTypeExistingPlane];
    if (results.count > 0) {
        [self putDownRoom:results.firstObject];
    }
}

- (void)putDownRoom:(ARHitTestResult *)result
{
    if (self.roomNode) {
        return;
    }
    DYHBoxRoomNode *boxRoom = [[DYHBoxRoomNode alloc] initWithWidth:3.f length:3.f height:3.f];
    boxRoom.skyBoxImages = @[@"nebulla_back_z",@"nebulla_front_z",@"nebulla_front_x",@"nebulla_back_x",@"nebulla_front_y",@"nebulla_back_y"];
    boxRoom.position = SCNVector3Make(result.worldTransform.columns[3].x, result.worldTransform.columns[3].y, result.worldTransform.columns[3].z);
    [self.sceneView.scene.rootNode addChildNode:boxRoom];
    self.roomNode = boxRoom;
}

@end
