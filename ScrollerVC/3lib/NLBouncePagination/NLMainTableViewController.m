//
//  NLMainTableViewController.m
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import "NLMainTableViewController.h"
#import "NLPullUpRefreshView.h"
#import "UIView+Additional.h"
@interface NLMainTableViewController ()

@property(nonatomic, strong)NLPullUpRefreshView *pullFreshView;
@property(nonatomic) NSInteger refreshCounter;

@end

@implementation NLMainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
    }
   
    // TODO: edgeInsetTop 要放到上层去设置
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.isResponseToScroll = YES;
}


- (void)addRefreshView {
    if (self.pullFreshView == nil) {
        float originY = self.tableView.contentSize.height;
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, originY+100);
        NSLog(@"originY == %f",originY);
        self.pullFreshView = [[NLPullUpRefreshView alloc]initWithFrame:CGRectMake(0, originY, self.view.frame.size.width, 50.f)];
        self.pullFreshView.backgroundColor= [UIColor redColor];
    }
    
    if (!self.pullFreshView.superview) {
        [self.pullFreshView setupWithOwner:self.tableView delegate:self];
    }
}

- (void)addSubPage
{
    if (!self.subTableViewController) {
        return;
    }
    
    self.subTableViewController.mainTableViewController = self;
    self.subTableViewController.tableView.frame = CGRectMake(0, self.tableView.contentSize.height-self.pullFreshView.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.tableView addSubview:self.subTableViewController.tableView];
}



- (void)pullUpRefreshDidFinish
{
    if (!self.refreshCounter) {
        self.refreshCounter = 0;
    }
    
    // 上拉分页动画
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(-self.tableView.contentSize.height-50+100, 0, 0, 0);
    }];
    self.isResponseToScroll = NO;
    self.tableView.bounces = NO;
    [self.pullFreshView stopLoading];
    self.pullFreshView.hidden = YES;
}

- (void)pullDownRefreshDidFinish
{
    [self.subTableViewController.pullFreshView stopLoading];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        // maintable重绘之后，contentsize要重新加上offset
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + 100.f);
    }];
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y +100.f);
    self.tableView.bounces = YES;
    self.isResponseToScroll = YES;
    self.pullFreshView.hidden = NO;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isResponseToScroll) {
        [self.pullFreshView scrollViewWillBeginDragging:scrollView];
    } else {
        [self.subTableViewController.pullFreshView scrollViewWillBeginDragging:scrollView];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isResponseToScroll) {
        [self.pullFreshView scrollViewDidScroll:scrollView];
    } else {
        [self.subTableViewController.pullFreshView scrollViewDidScroll:scrollView];
    }
    

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.isResponseToScroll) {
        [self.pullFreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    } else {
        [self.subTableViewController.pullFreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isResponseToScroll) {
        [self.pullFreshView scrollViewDidEndDecelerating:scrollView];
    } else {
        [self.subTableViewController.pullFreshView scrollViewDidScroll:scrollView];
    }

}


@end
