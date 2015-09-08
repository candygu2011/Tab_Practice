//
//  NLPullRefreshView.m
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#define REFRESH_PULL_UP_STATUS @"接下来您会"
#define REFRESH_RELEASED_STATUS @"接下来您会"
// 加载中
#define REFRESH_LOADING_STATUS @""
#define REFRESH_NO_MORE @"没有更多了"
#define REFRESHER_HEIGHT 50.0f

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kBottomGrayBackGroundColor UIColorFromRGB(0xf2f2f2)

#import "NLPullUpRefreshView.h"
#import "UIView+Additional.h"

@interface NLPullUpRefreshView ()

@end

@implementation NLPullUpRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBottomGrayBackGroundColor;
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, REFRESHER_HEIGHT)];
        bg.backgroundColor = kBottomGrayBackGroundColor;
        
        
        self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(bg.centerX-40, 8,80, REFRESHER_HEIGHT-15)];
        self.refreshLabel.backgroundColor = kBottomGrayBackGroundColor;
        self.refreshLabel.font = [UIFont systemFontOfSize:12.0];
        self.refreshLabel.textColor = [UIColor lightGrayColor];
        self.refreshLabel.textAlignment = NSTextAlignmentCenter;
        self.refreshLabel.text = REFRESH_PULL_UP_STATUS;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.refreshLabel.centerY, self.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];

        self.refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_xiala.png"]];
        self.refreshArrow.frame = CGRectMake(70,
                                        (floorf(60) / 2),
                                        15, 15);
        self.refreshArrow.centerX = self.refreshLabel.centerX;
        self.refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.refreshSpinner.frame = CGRectMake((frame.size.width - 20)/2, (REFRESHER_HEIGHT - 20)/2, 20, 20);
        self.refreshSpinner.hidesWhenStopped = YES;
        
        [bg addSubview:self.refreshLabel];
        [bg addSubview:line];
        [bg addSubview:self.refreshArrow];
        [bg addSubview:self.refreshSpinner];
        [bg sendSubviewToBack:line];
        [self addSubview:bg];
        self.hasMore = YES;
    }
    return self;
}

- (void)setupWithOwner:(UIScrollView *)owner  delegate:(id)delegate {
    self.owner = owner;
    self.delegate = delegate;
    
    [_owner addSubview:self];
}

- (void)updateOffsetY:(CGFloat)y
{
    CGRect originFrame = self.frame;
    self.frame = CGRectMake(originFrame.origin.x, y, originFrame.size.width, originFrame.size.height);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!isLoading && scrollView.contentOffset.y < 0) {
        return;
    }
    
    if (!self.hasMore) {
        self.refreshLabel.text = REFRESH_NO_MORE;
        self.refreshArrow.hidden = YES;
    }
    
    else if (isDragging && [self contentOffsetBottom:scrollView] <= 0 ) {
        
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        self.refreshArrow.hidden = NO;
        
        if ([self contentOffsetBottom:scrollView] <= -REFRESHER_HEIGHT) {
            
            // User is scrolling above the footer
            self.refreshLabel.text = REFRESH_RELEASED_STATUS;
//            [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
        
        else {
            
            // User is scrolling somewhere within the footer
            self.refreshLabel.text = REFRESH_PULL_UP_STATUS;
//            [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading || !self.hasMore) return;
    isDragging = NO;
    
    // 上拉刷新
    if(scrollView.contentOffset.y > 0 && [self contentOffsetBottom:scrollView] <= -REFRESHER_HEIGHT){
        [self startLoading];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isLoading || !self.hasMore) return;
    
    if(scrollView.contentOffset.y > 0 && [self contentOffsetBottom:scrollView] <= -REFRESHER_HEIGHT){
        [self startLoading];
    }
}

- (void)startLoading
{
    if (isLoading) {
        return;
    }
    isLoading = YES;
    
    // Show the footer
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
//        self.owner.contentInset = UIEdgeInsetsMake(REFRESHER_HEIGHT, 0, 0, 0);
    self.refreshLabel.text = REFRESH_LOADING_STATUS;
    self.refreshArrow.hidden = YES;
    [self.refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    if ([self.delegate respondsToSelector:@selector(pullUpRefreshDidFinish)]) {
        [self.delegate performSelector:@selector(pullUpRefreshDidFinish) withObject:nil];
    }
}

- (void)stopLoading
{
    isLoading = NO;
    
    // Hide the footer
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    
    [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    // Reset the footer
    NSLog(@"%f",self.owner.contentSize.height);
    
    self.refreshLabel.text = REFRESH_PULL_UP_STATUS;
    self.refreshArrow.hidden = NO;
    
    [self setFrame:CGRectMake(0, self.owner.contentSize.height, self.frame.size.width, 0)];
    [self.refreshSpinner stopAnimating];
}


// helper
// ------

- (float)contentOffsetBottom:(UIScrollView *)scrollView
{
    return scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom);
}

@end
