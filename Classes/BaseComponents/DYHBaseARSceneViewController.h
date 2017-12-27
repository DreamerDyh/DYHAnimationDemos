//
//  DYHBaseARSceneViewController.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/27.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

/*
 * 制作AR Demo的基类
 */

@interface DYHBaseARSceneViewController : UIViewController<ARSessionDelegate>

/*
 * SceneView
 */
@property (nonatomic, weak) ARSCNView *sceneView;

/*
 * 在底部显示各种session状态的Label
 */
@property (nonatomic, weak) UILabel *sessionInfoLabel;

/*
 * 默认为NO，为YES时会自动展示世界原点和特征点
 */
@property (nonatomic, assign) BOOL showDebugFeatures;

+ (NSString *)messageForTrackingWithFrame:(ARFrame *)frame trackingState:(ARTrackingState)trackingState trackingStateReason:(ARTrackingStateReason)reason;

/*
 本类中有实现的ARSessionDelegate方法，方便子类覆盖
 */
- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor *> *)anchors;

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor *> *)anchors;

- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera;

- (void)sessionWasInterrupted:(ARSession *)session;

- (void)sessionInterruptionEnded:(ARSession *)session;

- (void)session:(ARSession *)session didFailWithError:(NSError *)error;

@end
