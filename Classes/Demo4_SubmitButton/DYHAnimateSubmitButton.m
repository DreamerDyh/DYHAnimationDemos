//
//  DYHAnimateSubmitButton.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/4/1.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHAnimateSubmitButton.h"

@implementation DYHAnimateSubmitButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpStyles];
    }
    return self;
}

- (void)setUpStyles
{
    self.layer.borderColor = DYHAnimateSubmitButtonColor.CGColor;
    self.layer.borderWidth = 2.f;
    [self setTitleColor:DYHAnimateSubmitButtonColor forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius = self.bounds.size.height/2.f;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.layer.cornerRadius = self.bounds.size.height/2.f;
}

@end
