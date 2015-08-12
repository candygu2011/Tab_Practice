//
//  GMLCustomAlterView.m
//  ScrollerVC
//
//  Created by hi on 15/8/7.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "GMLCustomAlterView.h"
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define kMainBoundsWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度
#define kRect(x, y, w, h)    CGRectMake(x, y, w, h)
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define kKeyWindow [[UIApplication sharedApplication].windows lastObject]
#define kAnimateDuration 0.35f




@implementation GMLCustomAlterView

-(instancetype)initWithFrame:(CGRect)frame style:(GMLCustomAlterViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        if (style==0) {
            _contentViewHeight =  (kMainBoundsWidth - 55)*0.75;
        }else{
            _contentViewHeight = (kMainBoundsWidth - 55)*0.9;

        }
        _contentViewWidth = kMainBoundsWidth - 50;

        self.contentView = [[UIView alloc] initWithFrame:kRect(22.5, 0, _contentViewWidth, _contentViewHeight)];
        self.contentView.center = self.center;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)]];
        [self addSubview:self.contentView];
        
        if (style == 0) {
            _viewGap = (_contentViewHeight - 160)/3.0;
            [self initAlertViewStylePlain];
        }else{
            _viewGap = (_contentViewHeight - 175)/4.0;
            [self initAlertViewStyleGlobal];
        }

        
    }

    return self;
}

#pragma mark --
#pragma mark -- 普通的样式
- (void)initAlertViewStylePlain
{
    _imageView = [[UIImageView alloc] initWithFrame:kRect((_contentViewWidth - 90)/2, _viewGap, 100, 100)];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.image = [UIImage imageNamed:@"face_cry"];
    [_contentView addSubview:_imageView];
    
    _messageLabel = [[UILabel alloc] initWithFrame:kRect(0, _imageView.frame.size.height + _imageView.frame.origin.y + _viewGap , _contentView.frame.size.width, 20)];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:18];
    _messageLabel.textColor = kRGBColor(0x20, 0x20, 0x20);
//    _messageLabel.text = @" CGD是纯C的代码 所以它是函数不是方法（1）用同步的方式执行任务 dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);  参数说明：queue：队列 block：任务2）用异步的方式执行任务 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);以上两个函数都是将右边的参数（任务）放到左边的参数（队列）中执";
    [_contentView addSubview:_messageLabel];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = kRect(0, _contentView.frame.size.height - 49, _contentView.frame.size.width, 49);
    _confirmButton.backgroundColor = kRGBColor(0xff, 0xda, 0x44);
    [_confirmButton setTitleColor:kRGBColor(0x20, 0x20, 0x20) forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [_confirmButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_contentView addSubview:_confirmButton];
}
#pragma mark --
#pragma mark -- 全局的样式
- (void)initAlertViewStyleGlobal
{
    _imageView = [[UIImageView alloc] initWithFrame:kRect((_contentViewWidth - 90)/2, _viewGap, 100, 100)];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.image = [UIImage imageNamed:@"bg_kefu@2x"];
    [_contentView addSubview:_imageView];
    
    _messageLabel = [[UILabel alloc] initWithFrame:kRect(0, _imageView.frame.size.height + _imageView.frame.origin.y + _viewGap , _contentView.frame.size.width, 20)];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:18];
    _messageLabel.textColor = kRGBColor(0x20, 0x20, 0x20);
    _messageLabel.text = @"有大师回复你啦~";
//    [_contentView addSubview:_messageLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:kRect(0, _messageLabel.frame.size.height + _messageLabel.frame.origin.y + _viewGap , _contentView.frame.size.width, 15)];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textColor = kRGBColor(0xff, 0x44, 0x5a);
    _detailLabel.text = @"采纳最佳回复可获1积分";
//    [_contentView addSubview:_detailLabel];
    
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = kRect(0, _contentView.frame.size.height - 49, _contentView.frame.size.width/2, 49);
    _confirmButton.backgroundColor = kRGBColor(205, 205, 254);
    [_confirmButton setTitleColor:kRGBColor(0x20, 0x20, 0x20) forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setTitle:@"马上查看" forState:UIControlStateNormal];
    [_contentView addSubview:_confirmButton];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = kRect(_confirmButton.frame.size.width, _contentView.frame.size.height - 49, _contentView.frame.size.width - _confirmButton.frame.size.width, 49);
    _closeButton.backgroundColor = kRGBColor(156, 205, 254);
    [_closeButton setTitleColor:kRGBColor(0x20, 0x20, 0x20) forState:UIControlStateNormal];
    _closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitle:@"等会再看" forState:UIControlStateNormal];
    [_contentView addSubview:_closeButton];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:kRect(_contentView.frame.size.width/2, _contentView.frame.size.height - 49, 1, 49)];
    viewLine.backgroundColor = kRGBColor(0xe7, 0xbf, 0x1f);
    [_contentView addSubview:viewLine];
}

#pragma mark - 接口方法
- (void)showView
{
    [kKeyWindow addSubview:self];
    self.alpha = 1;
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        weakSelf.backgroundColor = RGBA(154, 154, 154, 0.6f);
    }];
}

- (void)hideView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


-(void)confirmClick
{
    [self hideView];

}

-(void)closeClick
{
    [self hideView];

}
@end
