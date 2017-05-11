//
//  DYHPageView.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/5/10.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYHPageView : UIView

- (instancetype)initWithImageUrls:(NSArray *)imageUrls frame:(CGRect)frame;

+ (instancetype)pageViewWithImageUrls:(NSArray *)imageUrls frame:(CGRect)frame;

- (void)reloadData;

- (void)jumpToIndex:(NSUInteger)index;

- (void)changeClipsToBoundsState:(BOOL)clipsToBounds;

@end
