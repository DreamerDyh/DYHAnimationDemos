//
//  DYHActiveButton.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/3/22.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHActiveButton.h"

@implementation DYHActiveButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpStyle];
    }
    return self;
}

- (void)setUpStyle
{
    self.layer.cornerRadius = kActiveButtonInnerMargin;
    self.layer.borderColor = kActiveButtonColor.CGColor;
    self.layer.borderWidth = 1.f;
    [self setTitleColor:kActiveButtonColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.contentEdgeInsets = UIEdgeInsetsMake(kActiveButtonInnerMargin, kActiveButtonInnerMargin, kActiveButtonInnerMargin, kActiveButtonInnerMargin);
    self.titleLabel.font = SYSFONT(14.f);

}

@end
