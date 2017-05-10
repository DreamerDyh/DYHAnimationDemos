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
#import "DYHPageViewController.h"

#define kNormalRootCellId @"NormalRootCellId"

typedef NS_ENUM(NSInteger, rowTags) {
    demo1_easy3d = 101,
    demo2_papaerPlane,
    demo3_liquidMenu,
    demo4_submitButton,
    demo5_helloAnimation,
    demo6_slowLiquidBall,
    demo7_pageView,
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
                   @(demo7_pageView):[DYHPageViewController class]
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
        case demo7_pageView:
            text = @"Demo7-PageView";
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
