
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


@interface AnimationViewController ()

@property (nonatomic,strong)  UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;


@property (strong, nonatomic)  UIImageView *keImge;
@property (strong, nonatomic)  UIImageView *lodingImage;
@property (strong, nonatomic)  UIImageView *touxiang;
@property (strong, nonatomic)  UILabel *welcomeLab;
@property (strong, nonatomic)  UILabel *devtalkingLabelCopy;




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
    
    
//    UILabel *devtalkingLabelCopy = [[UILabel alloc] initWithFrame:self.welcomeLab.frame];
//    devtalkingLabelCopy.alpha = 0;
//    devtalkingLabelCopy.text = self.welcomeLab.text;
//    devtalkingLabelCopy.font = self.welcomeLab.font;
//    devtalkingLabelCopy.textAlignment = self.welcomeLab.textAlignment;
//    devtalkingLabelCopy.textColor = self.welcomeLab.textColor;
//    devtalkingLabelCopy.backgroundColor = [UIColor clearColor];
//    self.devtalkingLabelCopy = devtalkingLabelCopy;
//    self.devtalkingLabelCopy.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.1), CGAffineTransformMakeTranslation(1.0, self.welcomeLab.height / 2));
//    [self.bgView4 addSubview:self.devtalkingLabelCopy ];
    
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
       // 添加
        [UIView transitionWithView:self.bgView4 duration:3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [self.bgView4 addSubview:self.welcomeLab];
            // label大小改变
            [UIView animateWithDuration:1 animations:^{
                self.welcomeLab.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.5), CGAffineTransformMakeTranslation(1.0, -self.welcomeLab.height / 2));
                self.welcomeLab.alpha = 0;
                
//                self.devtalkingLabelCopy.alpha = 1;
//                self.devtalkingLabelCopy.transform = CGAffineTransformIdentity;
     
            }];
            
        } completion:nil];
        
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


- (IBAction)goAction:(id)sender
{
  
    [self springAnimate];

}






@end
