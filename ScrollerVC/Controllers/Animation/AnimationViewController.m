
//
//  AnimationViewController.m
//  ScrollerVC
//
//  Created by hi on 15/10/9.
//  Copyright (c) 2015年 GML. All rights reserved.
//

typedef void(^Completion)();

#import "AnimationViewController.h"
#import "UIView+Additional.h"
#import "AnimationPracticeViewController.h"


@interface AnimationViewController ()

{
    CAShapeLayer *_ovalShapelayer;
}
@property (nonatomic,strong)  UIButton *loginBtn;
@property (nonatomic,strong) IBOutlet  UIImageView *backgroudImageView;

@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;


@property (strong, nonatomic)  UIImageView *keImge;
@property (strong, nonatomic)  UIImageView *lodingImage;
@property (strong, nonatomic)  UIImageView *touxiang;
@property (strong, nonatomic)  UILabel *welcomeLab;
@property (strong, nonatomic)  UILabel *devtalkingLabelCopy;

@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (weak, nonatomic) IBOutlet UIView *musicView;


@end

@implementation AnimationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(100, 180, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"阻尼动画" forState:UIControlStateNormal];
    self.loginBtn  = btn;
    [self.view addSubview:btn];
    
    self.loginBtn.centerY += 30;
    self.loginBtn.alpha = 0;
    
    if (_ovalShapelayer == nil) {
        _ovalShapelayer = [CAShapeLayer layer];
        }
    _ovalShapelayer.strokeColor = [UIColor redColor].CGColor;
    _ovalShapelayer.fillColor = [UIColor clearColor].CGColor;
    _ovalShapelayer.lineWidth = 7;
    CGFloat ovalRadius = self.loadingView.size.height / 2 * 0.8;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.loadingView.frame.size.width / 2 - ovalRadius, self.loadingView.frame.size.height / 2 - ovalRadius, ovalRadius * 2, ovalRadius *2)];
    _ovalShapelayer.path = path.CGPath;
    _ovalShapelayer.lineCap = kCALineCapRound;
    _ovalShapelayer.strokeEnd = 0.6;
    [self.loadingView.layer addSublayer:_ovalShapelayer];

    
    [self beginComplexAnimation];
    
    [self musicWaveAnimation];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keImge = [[UIImageView alloc] init];
    self.keImge.frame = CGRectMake(0, 0, 200, 151.5);
    self.keImge.image = [UIImage imageNamed:@"bg_kefu@2x"];
    
    self.lodingImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,  10, 50, 50)];
    self.lodingImage.image = [UIImage imageNamed:@"loading1@2x"];
    
    
    self.touxiang = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 50, 50)];
    self.touxiang.image = [UIImage imageNamed:@"touxiang@2x"];
    
    self.welcomeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.bgView4.width, 50)];
    self.welcomeLab.text = @"Welcome To My Home";
    self.welcomeLab.font = [UIFont systemFontOfSize:20];
    self.welcomeLab.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *devtalkingLabelCopy = [[UILabel alloc] initWithFrame:self.welcomeLab.frame];
    devtalkingLabelCopy.alpha = 0;
    devtalkingLabelCopy.text = self.welcomeLab.text;
    devtalkingLabelCopy.font = self.welcomeLab.font;
    devtalkingLabelCopy.textAlignment = self.welcomeLab.textAlignment;
    devtalkingLabelCopy.textColor = self.welcomeLab.textColor;
    devtalkingLabelCopy.backgroundColor = [UIColor clearColor];
    self.devtalkingLabelCopy = devtalkingLabelCopy;
    self.devtalkingLabelCopy.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.1), CGAffineTransformMakeTranslation(1.0, self.welcomeLab.height / 2));
    [self.bgView4 addSubview:self.devtalkingLabelCopy ];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self delay:0 completionBlock:^{
        
        [UIView transitionWithView:self.bgview duration:1.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self.bgview addSubview:self.lodingImage];
        } completion:nil];
    }];
    
    [self delay:1 completionBlock:^{
        
        [UIView transitionWithView:self.bgView2 duration:2.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [self.bgView2 addSubview:self.touxiang];
        } completion:nil];
    }];
    
    [self delay:2 completionBlock:^{
        [UIView transitionWithView:self.bgView3 duration:2 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [self.bgView3 addSubview:self.keImge];
        } completion:nil];
        
    }];
    
    
    [self delay:0 completionBlock:^{
        
        [self.bgView4 addSubview:self.welcomeLab];
        // label 伪3D动画
        [UIView animateWithDuration:1 animations:^{
            self.welcomeLab.alpha = 0;
            self.welcomeLab.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.5), CGAffineTransformMakeTranslation(1.0, -self.welcomeLab.height / 2));
            self.devtalkingLabelCopy.alpha = 1;
            self.devtalkingLabelCopy.transform = CGAffineTransformIdentity;
            
        }];
        // 背景切换动画
        [UIView transitionWithView:self.backgroudImageView duration:2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.backgroudImageView.image = [UIImage imageNamed:@"icn_nomusic"];
        } completion:nil];
        // 添加
//        [UIView transitionWithView:self.bgView4 duration:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//            [self.bgView4 addSubview:self.welcomeLab];
//            // label大小改变
//            [UIView animateWithDuration:1 animations:^{
//                self.welcomeLab.transform = CGAffineTransformMakeScale(1.0, 0.5);
//                self.welcomeLab.alpha = 0;
//                
////                self.devtalkingLabelCopy.alpha = 1;
////                self.devtalkingLabelCopy.transform = CGAffineTransformIdentity;
//     
//            }];
//            
//        } completion:nil];
        
    }];
    
    
    [self delay:4 completionBlock:^{
        [self springAnimate];
    }];
    
    
}
/// 延时函数
- (void)delay:(double)seconds completionBlock:(Completion)completion
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,seconds * NSEC_PER_SEC );
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        completion();
    });
    
}


// 阻尼动画  / 弹簧
- (void)springAnimate
{
    [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.loginBtn.centerY -= 30;
        self.loginBtn.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

// 圆弧旋转效果
- (void)beginSimpleAnimation
{
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.duration = 1.5;
    rotate.fromValue = [NSNumber numberWithDouble:0.0];
    rotate.toValue = [NSNumber numberWithDouble:2 * M_PI];
    rotate.repeatCount = MAXFLOAT;
    [self.loadingView.layer addAnimation:rotate forKey:nil];
}
// 网页加载动画
- (void)beginComplexAnimation
{
    CABasicAnimation *strokeStartAnimate = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimate.fromValue = [NSNumber numberWithFloat:-0.5];
    strokeStartAnimate.toValue = [NSNumber numberWithFloat:1.0];
    
    CABasicAnimation *strokeEndAnimate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimate.fromValue = [NSNumber numberWithFloat:0.0];
    strokeEndAnimate.toValue = [NSNumber numberWithFloat:1.0];
    
    CAAnimationGroup *strokeGroup = [CAAnimationGroup animation];
    strokeGroup.duration = 1.5;
    strokeGroup.repeatCount = MAXFLOAT;
    strokeGroup.animations = @[strokeStartAnimate,strokeEndAnimate];
    [_ovalShapelayer addAnimation:strokeGroup forKey:nil];
    
}
//  音乐效果
- (void)musicWaveAnimation
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(self.musicView.frame.origin.x, self.musicView.frame.origin.y, self.musicView.frame.size.width, self.musicView.frame.size.height);
    replicatorLayer.anchorPoint = CGPointMake(0, 0);
    replicatorLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.musicView.layer addSublayer:replicatorLayer];
    
    CALayer *rectangle = [CALayer layer];
    rectangle.bounds = CGRectMake(0, 0, 30, 90);
    rectangle.anchorPoint = CGPointMake(0, 0);
    rectangle.position = CGPointMake(self.musicView.frame.origin.x + 10, self.musicView.frame.origin.y + 90);
    rectangle.cornerRadius = 2;
    rectangle.backgroundColor = [UIColor whiteColor].CGColor;
    [replicatorLayer addSublayer:rectangle];
    
    CABasicAnimation *moveRectangle = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveRectangle.toValue =[NSNumber numberWithFloat: rectangle.position.y - 70];
    moveRectangle.duration = 0.7;
    moveRectangle.autoreverses = YES; // 反向运动
    moveRectangle.repeatCount = MAXFLOAT;
    [rectangle addAnimation:moveRectangle forKey:nil];
    
    replicatorLayer.instanceCount = 3;// 复制3份
    // CATransform3DMakeScale 大小变化
    // CATransform3DMakeTranslation  位置变化
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0);
    replicatorLayer.instanceDelay = 0.3;
    replicatorLayer.masksToBounds = YES;
    
}




@end
