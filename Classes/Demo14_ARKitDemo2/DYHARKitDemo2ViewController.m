//
//  DYHARKitDemo2ViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/28.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHARKitDemo2ViewController.h"
#import "DYHBoxRoomNode.h"

@interface DYHARKitDemo2ViewController ()

@end

@implementation DYHARKitDemo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNodes];
}

- (void)setUpNodes
{
    self.showDebugFeatures = YES;
    
    DYHBoxRoomNode *boxRoom = [[DYHBoxRoomNode alloc] initWithWidth:3.f length:3.f height:3.f];
    [self.sceneView.scene.rootNode addChildNode:boxRoom];
}

@end
