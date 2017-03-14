//
//  RootViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/14.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "RootViewController.h"

#define NormalRootCellId @"NormalRootCellId"

typedef NS_ENUM(NSInteger, rowTags) {
    rowDemo = 101,
};

@interface RootViewController ()

@property (nonatomic, strong) NSArray *demos;

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

- (NSArray *)demos
{
    if (!_demos) {
        _demos = @[@(rowDemo),@(rowDemo),@(rowDemo),@(rowDemo),@(rowDemo),@(rowDemo),@(rowDemo),@(rowDemo),@(rowDemo)];
    }
    return _demos;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellTag = [self cellTagForRow:(NSUInteger)indexPath.row];
    switch (cellTag) {
        case rowDemo:
            return [self normalCellWithText:@"demo1" showAccessory:YES];
            break;
        default:
            return [self normalCellWithText:@"⚠️error cell existance" showAccessory:NO];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger cellTag = [self cellTagForRow:(NSUInteger)indexPath.row];
    switch (cellTag) {
        case rowDemo:
            break;
            
        default:
            break;
    }
}

#pragma mark - 工具函数

- (NSInteger)cellTagForRow:(NSUInteger)row
{
    return [[self.demos objectAtIndex:row] integerValue];
}

- (UITableViewCell *)normalCellWithText:(NSString *)text showAccessory:(BOOL)showAccessory
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NormalRootCellId];
    cell.textLabel.text = text;
    cell.accessoryType = showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

@end
