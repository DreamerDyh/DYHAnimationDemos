//
//  RootViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/14.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "RootViewController.h"

#import "DYHEasy3DViewController.h"
#import "DYHPaperPlaneViewController.h"
#import "DYHLiquidMenuViewController.h"
#import "DYHSubmitButtonViewController.h"
#import "DYHHelloAnimationViewController.h"
#import "DYHSlowLiquidBallViewController.h"
#import "DYHEasyTransitionViewController.h"
#import "DYHSceneKitResearch1ViewController.h"
#import "DYHSceneKitResearch2ViewController.h"
#import "DYHSceneKitResearch3ViewController.h"
#import "DYHUIViewPropertyAnimatorViewController.h"
#import "DYHSceneKitDemo1ViewController.h"
#import "DYHARKitDemo1ViewController.h"
#import "DYHARKitDemo2ViewController.h"

#define kNormalRootCellId @"NormalRootCellId"

typedef NS_ENUM(NSInteger, rowTags) {
    demo1_easy3d = 101,
    demo2_papaerPlane,
    demo3_liquidMenu,
    demo4_submitButton,
    demo5_helloAnimation,
    demo6_slowLiquidBall,
    demo7_easyTransition,
    demo8_sceneKitResearch1,
    demo9_sceneKitResearch2,
    demo10_sceneKitResearch3,
    demo11_uiViewPropertyAnimator,
    demo12_sceneKitDemo1,
    demo13_arKitDemo1,
    demo14_arKitDemo2,
};

@interface RootViewController ()

@property (nonatomic, strong) NSDictionary *demos;

@property (nonatomic, strong) NSArray *orderdAllKeys;

@end

@implementation RootViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubViews];
}

- (void)setUpSubViews
{
    //配置title
    self.navigationItem.title = @"Demo List";
    
    //配置tableView的一些基本属性
    self.tableView.rowHeight = kDYHCellHeight;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kNormalRootCellId];
}

#pragma mark - Getter / Setter

- (NSDictionary *)demos
{
    if (!_demos) {
        _demos = @{
                   @(demo1_easy3d):[DYHEasy3DViewController class],
                   @(demo2_papaerPlane):[DYHPaperPlaneViewController class],
                   @(demo3_liquidMenu):[DYHLiquidMenuViewController class],
                   @(demo4_submitButton):[DYHSubmitButtonViewController class],
                   @(demo5_helloAnimation):[DYHHelloAnimationViewController class],
                   @(demo6_slowLiquidBall):[DYHSlowLiquidBallViewController class],
                   @(demo7_easyTransition):[DYHEasyTransitionViewController class],
                   @(demo8_sceneKitResearch1):[DYHSceneKitResearch1ViewController class],
                   @(demo9_sceneKitResearch2):[DYHSceneKitResearch2ViewController class],
                   @(demo10_sceneKitResearch3):[DYHSceneKitResearch3ViewController class],
                   @(demo11_uiViewPropertyAnimator):[DYHUIViewPropertyAnimatorViewController class],
                   @(demo12_sceneKitDemo1):[DYHSceneKitDemo1ViewController class],
                   @(demo13_arKitDemo1):[DYHARKitDemo1ViewController class],
                   @(demo14_arKitDemo2):[DYHARKitDemo2ViewController class],
                   };
    }
    return _demos;
}

- (NSArray *)orderdAllKeys
{
    if (!_orderdAllKeys) {
        _orderdAllKeys = [self.demos.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
    }
    return _orderdAllKeys;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderdAllKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellTag = [self cellTagForRow:(NSUInteger)indexPath.row];
    return [self normalCellWithText:[self textForCellTag:cellTag] showAccessory:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //根据cellTag解析出class
    NSInteger cellTag = [self cellTagForRow:(NSUInteger)indexPath.row];
    Class vcClass = [self.demos objectForKey:@(cellTag)];
    
    //创建并push对应的控制器
    UIViewController* vc = [vcClass new];
    vc.title = [self textForCellTag:cellTag];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 工具函数

- (NSInteger)cellTagForRow:(NSUInteger)row
{
    return [[self.orderdAllKeys objectAtIndex:row] integerValue];
}


- (NSString *)textForCellTag:(NSInteger)cellTag
{
    NSString *text = @"";
    switch (cellTag) {
        case demo1_easy3d:
            text = @"Demo1-简单3d变换";
            break;
        case demo2_papaerPlane:
            text = @"Demo2-纸飞机";
            break;
        case demo3_liquidMenu:
            text = @"Demo3-液态菜单";
            break;
        case demo4_submitButton:
            text = @"Demo4-提交按钮";
            break;
        case demo5_helloAnimation:
            text = @"Demo5-hello动画";
            break;
        case demo6_slowLiquidBall:
            text = @"Demo6-慢速液态球";
            break;
        case demo7_easyTransition:
            text = @"Demo7-简单转场";
            break;
        case demo8_sceneKitResearch1:
            text = @"Demo8-SceneKit研究1";
            break;
        case demo9_sceneKitResearch2:
            text = @"Demo9-SceneKit研究2";
            break;
        case demo10_sceneKitResearch3:
            text = @"Demo10-SceneKit研究3";
            break;
        case demo11_uiViewPropertyAnimator:
            text = @"Demo11-UIViewPropertyAnimator研究";
            break;
        case demo12_sceneKitDemo1:
            text = @"Demo12-SceneKitDemo1";
            break;
        case demo13_arKitDemo1:
            text = @"Demo13-ARKitDemo1";
            break;
        case demo14_arKitDemo2:
            text = @"Demo14-ARKitDemo2";
            break;
        default:
            text = @"404";
            break;
    }
    return text;
}

- (UITableViewCell *)normalCellWithText:(NSString *)text showAccessory:(BOOL)showAccessory
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kNormalRootCellId];
    cell.textLabel.text = text;
    cell.accessoryType = showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

@end
