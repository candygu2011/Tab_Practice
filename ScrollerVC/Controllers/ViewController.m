//
//  ViewController.m
//  ScrollerVC
//
//  Created by hi on 15/7/16.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "UIView+Extension.h"
#import "GMLUIViewController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
//颜色与随机颜色
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kARGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kRandomColor KRGBColor(arc4random() % 256 / 256.0, arc4random() % 256 / 256.0, arc4random() % 256 / 256.0)

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *redlineView;
@property (nonatomic, assign) int currentIndex;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"选项卡"];

    [self setupUI];
    
}

-(void)setupUI
{
    // 添加滚动视图
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 20, kScreenSize.width, 44);
    [self.view addSubview:self.topView];
    
    
    self.contentScrollView = [[UIScrollView alloc] init];
    CGFloat height = kScreenSize.height - CGRectGetHeight(self.topView.frame) - 64;
    self.contentScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenSize.width, height);
    [self.view addSubview:self.contentScrollView];
    
  
    
    CGFloat contentH = self.contentScrollView.bounds.size.height;
    CGFloat contentW = kScreenSize.width;
    CGFloat buttonW = kScreenSize.width / self.titles.count;
    [self.titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *titleBtn = [[UIButton alloc] init];
        titleBtn.frame = CGRectMake(idx * buttonW, 0, buttonW, CGRectGetHeight(self.topView.bounds));
        [titleBtn setTitle:obj forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        [titleBtn addTarget:self action:@selector(topViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:titleBtn];
        
        //
        
    }];
    // scorllView的contentSize
    
    // 添加子控件
    [self.titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // 添加子控件
        SecondViewController *subVC  = [[SecondViewController alloc] init];
        [self addChildViewController:subVC];
        subVC.view.frame = CGRectMake(idx * contentW, 0, contentW, contentH);
        [self.contentScrollView addSubview:subVC.view];

    }];
    
    // scorllView的contentSize
    self.contentScrollView.contentSize = CGSizeMake(contentW * self.titles.count, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;

    
    
    // 红条
    self.redlineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.topView.bounds) - 2, buttonW, 2)];
    self.redlineView.backgroundColor = [UIColor redColor];
    [self.topView addSubview:self.redlineView];

    
}
-(void)topViewButtonAction:(UIButton *)btn
{
    
}

-(void)initContentScrollView
{
    self.contentScrollView = [[UIScrollView alloc] init];
    CGFloat height = kScreenSize.height - CGRectGetHeight(self.topView.frame) - 64;
    self.contentScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenSize.width, height);
    [self.view addSubview:self.contentScrollView];

}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 控制器切换
    UIViewController *vc = self.childViewControllers[index];
    // 减少vc.view的添加
    if (vc.view.superview == nil) {
        CGSize size = self.contentScrollView.frame.size;
        vc.view.frame = CGRectMake(index * size.width, 0, size.width, size.height);
        [self.contentScrollView addSubview:vc.view];
    }
    
    [self.topView.subviews enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[UIButton class]]) {
            obj.selected = index == idx;
        }
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    BOOL right = offsetX > self.currentIndex * scrollView.bounds.size.width && offsetX <= (self.childViewControllers.count - 1) * scrollView.bounds.size.width;
    BOOL left = offsetX < self.currentIndex * scrollView.bounds.size.width && offsetX >= 0;
    int nextPage = self.currentIndex;
    if (right) {
        nextPage = self.currentIndex + 1;
    } else if (left) {
        nextPage = self.currentIndex - 1;
    }
    
    if (nextPage < 0 || nextPage > self.childViewControllers.count - 1) return;
    
    CGFloat percentage = (offsetX - self.currentIndex * scrollView.bounds.size.width) / scrollView.bounds.size.width;
    CGFloat moveX = self.currentIndex;
    if (left) {
        percentage += 1;
        moveX -= 1;
    }
    if (!(percentage < 0 || (nextPage >= self.childViewControllers.count)))
    {
        self.redlineView.x =  (moveX + percentage) * CGRectGetWidth(self.redlineView.frame);
    }
    
    // 重置currentIndex
    if (offsetX >= (self.currentIndex + 1) * scrollView.bounds.size.width && offsetX <= (self.childViewControllers.count - 1) * scrollView.bounds.size.width) {
        self.currentIndex = self.currentIndex + 1;
    } else if (offsetX <= (self.currentIndex - 1) * scrollView.bounds.size.width && offsetX >= 0) {
        self.currentIndex = self.currentIndex - 1;
    }
}


@end
