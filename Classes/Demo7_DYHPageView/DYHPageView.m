//
//  DYHPageView.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/5/10.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHPageView.h"

@interface DYHPageView()<UIScrollViewDelegate>

//subviews

@property (nonatomic, weak) UIScrollView *scrollView;

//datas

@property (nonatomic, strong) NSArray *originalImageUrls;

@property (nonatomic, strong) NSMutableArray *infinityImageUrls;

@property (nonatomic, assign) CGFloat pageWidth;

@property (nonatomic, assign) CGFloat pageGap;

@property (nonatomic, strong) NSMutableArray *waitingPool;

@property (nonatomic, strong) NSMutableArray *showingPool;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation DYHPageView

#pragma mark - Init

- (instancetype)initWithImageUrls:(NSArray *)imageUrls frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.originalImageUrls = imageUrls;
        self.pageWidth = frame.size.width - 100;
        self.pageGap = 10.f;
        [self setUpSubviews];
    }
    return self;
}

+ (instancetype)pageViewWithImageUrls:(NSArray *)imageUrls frame:(CGRect)frame
{
    return [[self alloc] initWithImageUrls:imageUrls frame:frame];
}

#pragma mark - Setter

- (void)setOriginalImageUrls:(NSArray *)originalImageUrls
{
    _originalImageUrls = originalImageUrls;
    
    if (originalImageUrls.count > 0) {
        
        //有数据时 利用原始imageUrls拼接无限循环imageUrls
        NSMutableArray *infinityImageUrls = [NSMutableArray array];
        [infinityImageUrls addObject:[originalImageUrls lastObject]];
        [infinityImageUrls addObjectsFromArray:originalImageUrls];
        [infinityImageUrls addObject:[originalImageUrls firstObject]];
        self.infinityImageUrls = infinityImageUrls;
    
    } else {
        self.infinityImageUrls = nil;
    }
}

#pragma mark - Getter

- (NSMutableArray *)showingPool
{
    if (!_showingPool) {
        _showingPool = [NSMutableArray array];
    }
    return _showingPool;
}

#pragma mark - SubViews

- (void)setUpSubviews
{
    CGFloat sWidth = self.bounds.size.width;
    CGFloat sHeight = self.bounds.size.height;
    CGFloat scrollViewWidth = self.pageWidth + self.pageGap;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((sWidth - scrollViewWidth) / 2, 0, scrollViewWidth, sHeight)];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
}

#pragma mark - 数据处理

- (NSUInteger)numberOfImageViews
{
    return self.infinityImageUrls.count;
}

- (UIImageView *)dequeueImageViewFromWaittingPool
{
    UIImageView *imageView = [UIImageView new];
    imageView.bounds = CGRectMake(0, 0, self.pageWidth, self.bounds.size.height);
    return imageView;
}

- (UIImageView *)imageViewForIndex:(NSUInteger)index
{
    UIImageView *imageView = [self dequeueImageViewFromWaittingPool];
    [self configureImageView:imageView withUrl:[self.infinityImageUrls objectAtIndex:index]];
    return imageView;
}

- (void)reloadData
{
    NSUInteger itemCount = [self numberOfImageViews];
    self.scrollView.contentSize = CGSizeMake(MAX(0, itemCount * (self.pageWidth + self.pageGap)), self.bounds.size.height);
    for (NSUInteger index = 0; index < itemCount; index++) {
        UIImageView *imageView = [self imageViewForIndex:index];
        CGFloat centerX = index * (self.pageWidth + self.pageGap) + self.pageGap/2 + self.pageWidth / 2;
        CGFloat centerY = self.bounds.size.height / 2.f;
        imageView.center = CGPointMake(centerX, centerY);
        if (![self.showingPool containsObject:imageView]) {
            [self.scrollView addSubview:imageView];
            [self.showingPool addObject:imageView];
        }
    }
}

- (void)configureImageView:(UIImageView *)imageView withUrl:(NSString *)imageUrl
{
    imageView.image = [UIImage imageNamed:imageUrl];
}

- (void)jumpToIndex:(NSUInteger)index
{
    self.scrollView.contentOffset = CGPointMake([self contentOffsetXForIndex:index], 0);
}

- (CGFloat)contentOffsetXForIndex:(NSUInteger)index
{
    return self.scrollView.frame.size.width * index;
}

- (NSUInteger)indexForStopContentOffsetX:(CGFloat)contentOffsetX
{
    return (NSUInteger)( contentOffsetX / self.scrollView.frame.size.width );
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = [self indexForStopContentOffsetX:scrollView.contentOffset.x];
    
    NSLog(@"%ld",index);
    if (index == 0) {
        [self jumpToIndex:self.originalImageUrls.count];
    } else if(index == self.infinityImageUrls.count - 1) {
        [self jumpToIndex:1];
    }
    
}

#pragma mark - Public Tool
- (void)changeClipsToBoundsState:(BOOL)clipsToBounds
{
    self.scrollView.clipsToBounds = clipsToBounds;
}

@end
