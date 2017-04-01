//
//  DYHAnimateSubmitButton.h
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 17/4/1.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DYHAnimateSubmitButtonColor RGBCOLOR(25, 204, 149)

@class DYHAnimateSubmitButton;

typedef void(^DYHAnimateSubmitButtonCompletion)();

@protocol DYHAnimateSubmitButtonDelegate <NSObject>

- (void)animateSubmitButtonWasClicked:(DYHAnimateSubmitButton *)sender;

@end

@interface DYHAnimateSubmitButton : UIView

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) id<DYHAnimateSubmitButtonDelegate> delegate;

- (void)doAnimationCompletion:(DYHAnimateSubmitButtonCompletion)completion;

@end
