//
//  RootViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/14.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "RootViewController.h"

#import "Easy3DViewController.h"

#define NormalRootCellId @"NormalRootCellId"

typedef NS_ENUM(NSInteger, rowTags) {
    demo1_easy3d = 101,
};

@interface RootViewController ()

@property (nonatomic, strong) NSDictionary *demos;

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
    self.navigationItem.title = @"Menu";
    
    //配置tableView的一些基本属性
    self.tableView.rowHeight = DYHCellHeight;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NormalRootCellId];
}

#pragma mark - Getter / Setter

- (NSDictionary *)demos
{
    if (!_demos) {
        _demos = @{
                   @(demo1_easy3d):[Easy3DViewController class]
                   };
    }
    return _demos;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demos.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellTag = [self cellTagForRow:(NSUInteger)indexPath.row];
    NSString *text;
    switch (cellTag) {
        case demo1_easy3d:
            text = @"Demo1-简单3d变换";
            break;
        default:
            text = @"404";
            break;
    }
    return [self normalCellWithText:text showAccessory:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //根据cellTag解析出class
    NSInteger cellTag = [self cellTagForRow:(NSUInteger)indexPath.row];
    Class vcClass = [self.demos objectForKey:@(cellTag)];
    
    //创建并push对应的控制器
    UIViewController* vc = [vcClass new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 工具函数

- (NSInteger)cellTagForRow:(NSUInteger)row
{
    return [[self.demos.allKeys objectAtIndex:row] integerValue];
}

- (UITableViewCell *)normalCellWithText:(NSString *)text showAccessory:(BOOL)showAccessory
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NormalRootCellId];
    cell.textLabel.text = text;
    cell.accessoryType = showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

@end
