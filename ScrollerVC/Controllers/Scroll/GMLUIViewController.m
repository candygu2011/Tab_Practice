//
//  GMLUIViewController.m
//  微博个人详情页
//
//  Created by hi on 15/10/19.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import "GMLUIViewController.h"
static CGFloat const headH = 200;
static CGFloat const headMainH = 64;
static CGFloat const tabBarH = 44;


@interface GMLUIViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHConstraint;

@property (nonatomic,assign) CGFloat lastOffsetY;

@end
@implementation GMLUIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _lastOffsetY = - (headH + tabBarH);
    self.tableView.contentInset = UIEdgeInsetsMake(headH + tabBarH, 0, 0, 0);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"测试";
    [nameLabel sizeToFit];
    self.navigationItem.titleView = nameLabel;
    _nameLabel = nameLabel;
    nameLabel.alpha = 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID
                ];
        //        cell.backgroundColor = [UIColor redColor];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY - _lastOffsetY;
    CGFloat height = headH - delta;
    if (height < headMainH) {
        height = headMainH;
    }
    _headerHConstraint.constant = height;
    CGFloat alpha = delta / (headH - headMainH);
    if (alpha >= 1) {
        alpha = 0.99;
    }
    _nameLabel.alpha = alpha;
    
    UIImage *image = [self imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
   
    NSLog(@"%@",NSStringFromCGSize(scrollView.contentSize));

}


- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
