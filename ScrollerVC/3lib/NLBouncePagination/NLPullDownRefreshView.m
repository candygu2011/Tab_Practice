//
//  NLPullDownRefreshView.m
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import "NLPullDownRefreshView.h"
#import "UIView+Additional.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kBottomGrayBackGroundColor UIColorFromRGB(0xf2f2f2)

#define REFRESH_PULL_UP_STATUS @"返回报价详情"
#define REFRESH_RELEASED_STATUS @"返回报价详情"
// 加载中
#define REFRESH_LOADING_STATUS @""
#define REFRESHER_HEIGHT 50.0f

@interface NLPullDownRefreshView ()

@end

@implementation NLPullDownRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBottomGrayBackGroundColor;
        
        self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerX-40, 8,80, REFRESHER_HEIGHT-15)];
        self.refreshLabel.backgroundColor = kBottomGrayBackGroundColor;
        self.refreshLabel.font = [UIFont systemFontOfSize:12.0];
        self.refreshLabel.textColor = [UIColor lightGrayColor];
        self.refreshLabel.textAlignment = NSTextAlignmentCenter;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.refreshLabel.centerY, self.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        self.refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_xiala.png"]];
        self.refreshArrow.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        self.refreshArrow.frame = CGRectMake(70,5,
                                             15, 15);
        self.refreshArrow.centerX = self.refreshLabel.centerX;

        
        self.refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.refreshSpinner.frame = CGRectMake((frame.size.width - 20)/2, (REFRESHER_HEIGHT - 20)/2, 20, 20);
        self.refreshSpinner.hidesWhenStopped = YES;
        
        [self addSubview:self.refreshLabel];
        [self addSubview:line];
        [self addSubview:self.refreshArrow];
//        [self addSubview:self.refreshSpinner];
        [self sendSubviewToBack:line];

    }
    return self;
}

- (void)setupWithOwner:(UIScrollView *)owner  delegate:(id)delegate {
    self.owner = owner;
    self.delegate = delegate;
    
    [_owner addSubview:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (isLoading && scrollView.contentOffset.y > 0) {
        return;
    }
    
    if (isDragging && scrollView.contentOffset.y <= 0 ) {
        
        [self.refreshSpinner stopAnimating];
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        
        if (scrollView.contentOffset.y <= -REFRESHER_HEIGHT) {
            
            // User is scrolling above the header
            self.refreshLabel.text = REFRESH_RELEASED_STATUS;
        }
        
        else {
            
            // User is scrolling somewhere within the header
            self.refreshLabel.text = REFRESH_PULL_UP_STATUS;
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    
    // 上拉刷新
    if(scrollView.contentOffset.y <= -REFRESHER_HEIGHT){
        [self startLoading];
    }
}


- (void)startLoading
{
    if (isLoading) {
        return;
    }
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.refreshLabel.text = REFRESH_LOADING_STATUS;
    [self.refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    if ([self.delegate respondsToSelector:@selector(pullDownRefreshDidFinish)]) {
        [self.delegate performSelector:@selector(pullDownRefreshDidFinish) withObject:nil];
    }
}

- (void)stopLoading
{
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1];
    
    [UIView commitAnimations];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    // Reset the header
    NSLog(@"subTableView size = %f",self.owner.contentSize.height);
    
    self.refreshLabel.text = REFRESH_PULL_UP_STATUS;
    
    [self setFrame:CGRectMake(0, -REFRESHER_HEIGHT, self.frame.size.width, 0)];
    [self.refreshSpinner stopAnimating];
}


@end
