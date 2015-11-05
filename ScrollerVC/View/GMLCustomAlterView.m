//
//  GMLCustomAlterView.m
//  ScrollerVC
//
//  Created by hi on 15/8/7.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "GMLCustomAlterView.h"
#define kMainBoundsHeight   [[UIScreen mainScreen] applicationFrame].size.height //屏幕的高度
#define kMainBoundsWidth    [[UIScreen mainScreen] applicationFrame].size.width //屏幕的宽度
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
        if (style==GMLCustomAlterViewStylePlain) {
            _contentViewHeight =  (kMainBoundsWidth - 55)*0.75;
        }else{
            _contentViewHeight = (kMainBoundsWidth - 55)*0.9;

        }
        _contentViewWidth = kMainBoundsWidth - 50;
        self.contentView = [[UIView alloc] initWithFrame:kRect(22.5, 0, _contentViewWidth, _contentViewHeight)];
        self.contentView.center = self.center;
        self.contentView.layer.cornerRadius = 5;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)]];
        [self addSubview:self.contentView];
        
        if (style == GMLCustomAlterViewStylePlain) {
            _viewGap = (_contentViewHeight - 160)/3.0;
            [self initAlertViewStylePlainWithContent:@"是否保存当前绘制的内容"];
        }else{
            _viewGap = (_contentViewHeight - 175)/4.0;
            [self initAlertViewStyleGlobalTitle:@"重要提示" content:@"你好啊啊"];
        }

        
    }

    return self;
}

#pragma mark --
#pragma mark -- 普通的样式
- (void)initAlertViewStylePlainWithContent:(NSString *)content
{

    _messageLabel = [[UILabel alloc] initWithFrame:kRect(0, _contentView.bounds.size.height * 0.2 , _contentView.frame.size.width, 20)];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:18];
    _messageLabel.textColor = kRGBColor(0x20, 0x20, 0x20);
    _messageLabel.text = content ;
    [_contentView addSubview:_messageLabel];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = kRect(0, _contentView.frame.size.height - 49, _contentView.frame.size.width/2, 49);
    _confirmButton.backgroundColor = [UIColor clearColor];
    [_confirmButton setTitleColor:kRGBColor(0x20, 0x20, 0x20) forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setTitle:@"取消" forState:UIControlStateNormal];
    [_contentView addSubview:_confirmButton];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = kRect(_confirmButton.frame.size.width, _contentView.frame.size.height - 49, _contentView.frame.size.width - _confirmButton.frame.size.width, 49);
    _closeButton.backgroundColor = [UIColor clearColor];
    [_closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitle:@"确认" forState:UIControlStateNormal];
    [_contentView addSubview:_closeButton];
    
    UIView *viewLine1 = [[UIView alloc] initWithFrame:kRect(0, _closeButton.frame.origin.y, _contentView.bounds.size.width, 0.5)];
    viewLine1.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:viewLine1];
    
    UIView *viewLine2 = [[UIView alloc] initWithFrame:kRect(_contentView.frame.size.width/2, _contentView.frame.size.height - 49, 0.5, 49)];
    viewLine2.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:viewLine2];

}

#pragma mark -- 样式1 带title
- (void)initAlertViewStyleGlobalTitle:(NSString *)title content:(NSString *)content
{
    
    _titleLabel = [[UILabel alloc] initWithFrame:kRect((_contentViewWidth - 90)/2, _viewGap, 100, 20)];
    _titleLabel.backgroundColor = [UIColor redColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    _titleLabel.text = title;
    [_contentView addSubview:_titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _viewGap+_titleLabel.frame.size.height,_contentView.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:line];

    
    _messageLabel = [[UILabel alloc] initWithFrame:kRect(0, _titleLabel.frame.size.height + _titleLabel.frame.origin.y + _viewGap , _contentView.frame.size.width, 20)];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.backgroundColor = [UIColor yellowColor];
    _messageLabel.font = [UIFont systemFontOfSize:18];
    _messageLabel.textColor = kRGBColor(0x20, 0x20, 0x20);
    _messageLabel.text = content;
    [_contentView addSubview:_messageLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:kRect(0, _messageLabel.frame.size.height + _messageLabel.frame.origin.y + _viewGap , _contentView.frame.size.width, 15)];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textColor = kRGBColor(0xff, 0x44, 0x5a);
    _detailLabel.text = @"采纳最佳回复可获1积分纳最佳回复可获1积分纳最佳回复可获1积分纳最佳回复可获1积分";
    [_contentView addSubview:_detailLabel];
    
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = kRect(0, _contentView.frame.size.height - 49, _contentView.frame.size.width/2, 49);
    _confirmButton.backgroundColor = [UIColor clearColor];
    [_confirmButton setTitleColor:kRGBColor(0x20, 0x20, 0x20) forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setTitle:@"取消" forState:UIControlStateNormal];
    [_contentView addSubview:_confirmButton];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = kRect(_confirmButton.frame.size.width, _contentView.frame.size.height - 49, _contentView.frame.size.width - _confirmButton.frame.size.width, 49);
    _closeButton.backgroundColor = [UIColor clearColor];
    [_closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitle:@"确认" forState:UIControlStateNormal];
    [_contentView addSubview:_closeButton];
    
    UIView *viewLine1 = [[UIView alloc] initWithFrame:kRect(0, _closeButton.frame.origin.y, _contentView.bounds.size.width, 0.5)];
    viewLine1.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:viewLine1];
    
    UIView *viewLine2 = [[UIView alloc] initWithFrame:kRect(_contentView.frame.size.width/2, _contentView.frame.size.height - 49, 0.5, 49)];
    viewLine2.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:viewLine2];
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
        weakSelf.backgroundColor = RGBA(62, 62, 62, 1.0f);
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
