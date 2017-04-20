//
//  DYHLiquidMenuViewController.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/30.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHLiquidMenuViewController.h"
#import "DYHLiquidView.h"

typedef NS_ENUM(NSUInteger, LiquidTag) {
    LiquidTagRoot = 101,
    LiquidTag1,
    LiquidTag2,
    LiquidTag3,
    LiquidTag4,
};

@interface DYHLiquidMenuViewController ()<DYHLiquidViewDelegate>

@property (nonatomic, strong) NSArray *liquidViews;

@property (nonatomic, assign) BOOL isPushing;

@end

@implementation DYHLiquidMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将根view添加好
    DYHLiquidView* liquidView = [self.liquidViews firstObject];
    liquidView.iconName = @"search_icon";
    liquidView.tag= LiquidTagRoot;
    liquidView.delegate = self;
    [self.view addSubview:liquidView];
    liquidView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*0.7);
    
    DYHLiquidView *view1 = [self.liquidViews objectAtIndex:1];
    view1.iconName = @"push_icon";
    view1.tag = LiquidTag1;
    DYHLiquidView *view2 = [self.liquidViews objectAtIndex:2];
    view2.iconName = @"address_icon";
    view2.tag = LiquidTag2;
    DYHLiquidView *view3 = [self.liquidViews objectAtIndex:3];
    view3.iconName = @"team_icon";
    view3.tag = LiquidTag3;
    DYHLiquidView *view4 = [self.liquidViews objectAtIndex:4];
    view4.iconName = @"send_icon";
    view4.tag = LiquidTag4;

}

- (NSArray *)liquidViews
{
    if (!_liquidViews) {
        _liquidViews = @[[DYHLiquidView liquidViewWithQuadWidth:60.f contentBgColor:LiquidColor],[DYHLiquidView liquidViewWithQuadWidth:50.f contentBgColor:LiquidColor],[DYHLiquidView liquidViewWithQuadWidth:50.f contentBgColor:LiquidColor],[DYHLiquidView liquidViewWithQuadWidth:50.f contentBgColor:LiquidColor],[DYHLiquidView liquidViewWithQuadWidth:50.f contentBgColor:LiquidColor]];
    }
    return _liquidViews;
}

#pragma mark - DYHLiquidViewDelegate

- (void)liquidViewWasClicked:(DYHLiquidView *)liquidView
{
    if (self.isAnimating) {
        return;
    }
    
    if (liquidView.tag == LiquidTagRoot) {
        DYHLiquidView *view1 = [self.liquidViews objectAtIndex:1];
        DYHLiquidView *view2 = [self.liquidViews objectAtIndex:2];
        DYHLiquidView *view3 = [self.liquidViews objectAtIndex:3];
        DYHLiquidView *view4 = [self.liquidViews objectAtIndex:4];
   
        if (self.isPushing) {
            //pop
            self.isAnimating = YES;
            [view3 popPushedViewWithDelay:0.f];
            [view2 popPushedViewWithDelay:0.1f];
            [view1 popPushedViewWithDelay:0.2f];
            [liquidView popPushedViewWithDelay:0.3f completion:^(DYHLiquidView *pushedView) {
                self.isPushing = NO;
                self.isAnimating = NO;
            }];
        } else {
            //push
            self.isAnimating = YES;
            [liquidView pushLiquidView:view1 delay:0.f completion:nil];
            [view1 pushLiquidView:view2 delay:0.1f completion:nil];
            [view2 pushLiquidView:view3 delay:0.2f completion:nil];
            [view3 pushLiquidView:view4 delay:0.3f completion:^(DYHLiquidView *pushedView) {
                self.isPushing = YES;
                self.isAnimating = NO;
            }];
            
        }
    }
}

@end
