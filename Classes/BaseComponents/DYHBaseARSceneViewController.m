//
//  DYHBaseARSceneViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/12/27.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHBaseARSceneViewController.h"

@interface DYHBaseARSceneViewController ()

@end

@implementation DYHBaseARSceneViewController

#pragma mark - Set / Get
- (void)setShowDebugFeatures:(BOOL)showDebugFeatures
{
    _showDebugFeatures = showDebugFeatures;
    if (showDebugFeatures) {
        self.sceneView.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
    } else {
        self.sceneView.debugOptions = SCNDebugOptionNone;
    }
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSceneSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([ARWorldTrackingConfiguration isSupported]) {
        self.sessionInfoLabel.text = @"ARKit Available";
    }
    
    //viewDidAppear时，开始worldTracking
    [self resetTracking];
    self.sceneView.session.delegate = self;
    
    //使应用持续保持响应
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //开启fps等的显示
    //self.sceneView.showsStatistics = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //取消持续响应
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //暂停session
    [self.sceneView.session pause];
}

#pragma mark - Subviews

- (void)setUpSceneSubviews
{
    //scnView
    ARSCNView *scnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scnView];
    self.sceneView = scnView;
    
    //infoLabel
    UILabel *infoLabel = [UILabel new];
    infoLabel.numberOfLines = 0;
    infoLabel.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8f];
    infoLabel.textColor = [UIColor darkGrayColor];
    infoLabel.font = [UIFont systemFontOfSize:25.f weight:UIFontWeightThin];
    [self.view addSubview:infoLabel];
    self.sessionInfoLabel = infoLabel;
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - ARSessionDelegate

- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor *> *)anchors
{
    ARFrame *frame = session.currentFrame;
    if (frame) {
        [self updateSessionInfoLabelWithFrame:frame trackingState:frame.camera.trackingState trackingStateReason:frame.camera.trackingStateReason];
    } else { return; }
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor *> *)anchors
{
    ARFrame *frame = session.currentFrame;
    if (frame) {
        [self updateSessionInfoLabelWithFrame:frame trackingState:frame.camera.trackingState trackingStateReason:frame.camera.trackingStateReason];
    } else { return; }
}

- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera
{
    ARFrame *frame = session.currentFrame;
    [self updateSessionInfoLabelWithFrame:frame trackingState:frame.camera.trackingState trackingStateReason:frame.camera.trackingStateReason];
}

#pragma mark - ARSessionObserver

- (void)sessionWasInterrupted:(ARSession *)session
{
    self.sessionInfoLabel.text = @"⚠️AR Session被中断";
}

- (void)sessionInterruptionEnded:(ARSession *)session
{
    self.sessionInfoLabel.text = @"⚠️AR Session中断结束，正在重启...";
    [self resetTracking];
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error
{
    self.sessionInfoLabel.text = [NSString stringWithFormat:@"❗️AR Session出现错误: %@，正在重启...",error.localizedDescription];
    [self resetTracking];
}

#pragma mark - Tool

- (void)updateSessionInfoLabelWithFrame:(ARFrame *)frame trackingState:(ARTrackingState)trackingState trackingStateReason:(ARTrackingStateReason)reason
{
    self.sessionInfoLabel.text = [DYHBaseARSceneViewController messageForTrackingWithFrame:frame trackingState:trackingState trackingStateReason:reason];
}

- (void)resetTracking
{
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    configuration.lightEstimationEnabled = YES;
    [self.sceneView.session runWithConfiguration:configuration];
}

#pragma mark - Public

+ (NSString *)messageForTrackingWithFrame:(ARFrame *)frame trackingState:(ARTrackingState)trackingState trackingStateReason:(ARTrackingStateReason)reason
{
    NSString *message = @"";
    
    switch (trackingState) {
        case ARTrackingStateNormal:{
            if (frame.anchors.count == 0) {
                message = @"请来回移动设备以寻找平面";
            }
        }break;
            
        case ARTrackingStateLimited:{
            switch (reason) {
                case ARTrackingStateReasonExcessiveMotion:{
                    message = @"⚠️Tracking Limited-请放慢移动设备的速度";
                }break;
                case ARTrackingStateReasonInsufficientFeatures:{
                    message = @"⚠️Tracking Limited-请将设备放置在更能看清细节的位置，或提高照明";
                }break;
                case ARTrackingStateReasonInitializing:{
                    message = @"正在初始化AR...";
                }break;
                default:break;
            }
        }break;
            
        case ARTrackingStateNotAvailable:{
            message = @"⚠️Tracking不可用";
        }break;
            
        default:break;
    }
    
    return message;
}

@end
