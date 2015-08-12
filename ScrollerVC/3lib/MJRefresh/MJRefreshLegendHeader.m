//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshLegendHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshLegendHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"

@interface MJRefreshLegendHeader()
@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIImageView *animationImageView;
@end

@implementation MJRefreshLegendHeader
#pragma mark - 懒加载
//- (UIImageView *)arrowImage
//{
//    if (!_arrowImage) {
//        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
//        [self addSubview:_arrowImage = arrowImage];
//    }
//    return _arrowImage;
//}
//
//- (UIActivityIndicatorView *)activityView
//{
//    if (!_activityView) {
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activityView.bounds = self.arrowImage.bounds;
//        [self addSubview:_activityView = activityView];
//    }
//    return _activityView;
//}


#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    //自定义的下拉刷新控件
    
    if (_animationImageView == nil) {
        
        CGFloat stateH = self.mj_h * 0.55;
        CGFloat updatedTimeY = stateH;
        self.animationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
        self.animationImageView.frame = CGRectMake((self.mj_w-35)/2, updatedTimeY-20, 35, 35);
        [self addSubview:self.animationImageView];
    }
    

    [self startAnimation];

    
}

#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing) {
   
//                [self.animationImageView.layer removeAllAnimations];
                
            } else {

                
                
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {

            
            [self.animationImageView.layer removeAllAnimations];
            

            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
            
            [self startAnimation];

            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

- (void)startAnimation {
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = NO;
    rotationAnimation.repeatCount = DBL_MAX;
    [self.animationImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}



@end
