//
//  ViewController.m
//  图片轮播
//
//  Created by isoftstone on 16/3/28.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ViewController.h"
#define kImageNumber 5

@interface ViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

//定时器
- (void)timerStart {

  //创建定时器
  self.timer = [NSTimer timerWithTimeInterval:2.0
                                       target:self
                                     selector:@selector(updateTimer)
                                     userInfo:nil
                                      repeats:YES];
  //加入和滚动相同的运行循环
  [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//定时器触发事件
- (void)updateTimer {
  self.pageControl.currentPage = (self.pageControl.currentPage + 1) % 5;
  int n = (int)self.pageControl.currentPage;
  NSLog(@"n:%d", n);

  [self pageChange:self.pageControl];
}

//分页控件
- (UIPageControl *)pageControl {
  if (_pageControl == nil) {
    _pageControl = [[UIPageControl alloc] init];
    //设置页数
    _pageControl.numberOfPages = kImageNumber;
    //设置大小
    CGSize size = [_pageControl sizeForNumberOfPages:kImageNumber];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    //设置中心
    _pageControl.center = CGPointMake(self.view.center.x, 130);
    //设置圆点颜色
    _pageControl.pageIndicatorTintColor = [UIColor redColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];

    //添加监听
    [_pageControl addTarget:self
                     action:@selector(pageChange:)
           forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:_pageControl];
  }

  return _pageControl;
}

// pageControll监听触发方法
- (void)pageChange:(UIPageControl *)pageControl {
  int n = (int)pageControl.currentPage;
  NSLog(@"pageChange n:%d", n);
  CGFloat x = n * self.scrollView.frame.size.width;
  [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

//滚动
- (UIScrollView *)scrollView {
  if (_scrollView == nil) {

    CGFloat w = self.view.frame.size.width - 20;
    _scrollView =
        [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, w, 130)];

    //设置图片
    for (int i = 1; i <= kImageNumber; i++) {
      NSString *imageName = [[NSString alloc] initWithFormat:@"img_%02d", i];
      UIImage *image = [UIImage imageNamed:imageName];
      UIImageView *imageView =
          [[UIImageView alloc] initWithFrame:_scrollView.bounds];
      imageView.image = image;
      [_scrollView addSubview:imageView];
    }

    //设置图片位置
    [_scrollView.subviews
        enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx,
                                     BOOL *_Nonnull stop) {

          CGRect frame = imageView.frame;
          frame.origin.x = idx * _scrollView.frame.size.width;
          imageView.frame = frame;

        }];

    //设置要显示图像的大小
    _scrollView.contentSize = CGSizeMake(kImageNumber * w, 130);
    //设置可以翻页
    _scrollView.pagingEnabled = YES;
    //去掉滚动条
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    //设置无边沿弹簧效果
    _scrollView.bounces = NO;

    //设置代理
    _scrollView.delegate = self;

    [self.view addSubview:_scrollView];
  }

  return _scrollView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  [self scrollView];
  [self pageControl];
  [self timerStart];
}

#pragma mark scrollView 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  int pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;

  NSLog(@"pageNumber:%d", pageNumber);

  self.pageControl.currentPage = pageNumber;
}

//拖拽将要开始时触发
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  //停止定时器
  [self.timer invalidate];
}

//拖拽将要结束时触发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  //重新启动定时器
  [self timerStart];
}

@end
