//
//  BasicAnimationViewController.m
//  ScrollerVC
//
//  Created by hi on 15/11/5.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "BasicAnimationViewController.h"

@interface BasicAnimationViewController ()
{
    UIView *_view1;
    UIView *_view2;
    
    CALayer *scaleLayer;
    CALayer *moveLayer;
    CALayer *rotateLayer;
    CALayer *groupLayer;
    
}
@property (weak, nonatomic) IBOutlet UIButton *basicAnimBtn;

@end

@implementation BasicAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    _view1 = [[UIView alloc] initWithFrame:self.view.frame];
    _view1.backgroundColor = [UIColor lightGrayColor];
    _view2 = [[UIView alloc] initWithFrame:self.view.frame];
    _view2.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_view1];
    [self.view sendSubviewToBack:_view1];
}

// 翻页效果
- (IBAction)curlDownAction:(id)sender {
  
    [self doTransitionWithType:UIViewAnimationOptionTransitionCurlDown];
}
- (IBAction)curlUp:(id)sender {
    [self doTransitionWithType:UIViewAnimationOptionTransitionCurlUp];

}

- (IBAction)flipFromTop:(id)sender {
    [self doTransitionWithType:UIViewAnimationOptionTransitionFlipFromTop];
}
- (IBAction)flipFromLeft:(id)sender {
    [self doTransitionWithType:UIViewAnimationOptionTransitionFlipFromLeft];
}
- (IBAction)dissolve:(id)sender {
    [self doTransitionWithType:UIViewAnimationOptionTransitionCrossDissolve];
}


- (IBAction)basicAnimation:(id)sender {
    [self initScaleLayer];
    [self initMoveLayer];
    [self initRotateLayer];
    [self initGroupLayer];

 }

- (void)initScaleLayer
{
    //演员初始化
    scaleLayer = [[CALayer alloc] init];
    scaleLayer.backgroundColor = [UIColor blueColor].CGColor;
    scaleLayer.frame = CGRectMake(60, 20, 50, 50);
    scaleLayer.cornerRadius = 10;
    [self.view.layer addSublayer:scaleLayer];
    
    //设定剧本
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 0.8;
    
    //开演
    [scaleLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)initMoveLayer
{
    //演员初始化
    moveLayer = [[CALayer alloc] init];
    moveLayer.backgroundColor = [UIColor redColor].CGColor;
    moveLayer.frame = CGRectMake(60, 130 , 50, 50);
    moveLayer.cornerRadius = 10;
    [self.view.layer addSublayer:moveLayer];
    
    //设定剧本
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:moveLayer.position];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(320 - 80,
                                                                  moveLayer.position.y)];
    moveAnimation.autoreverses = YES;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.repeatCount = MAXFLOAT;
    moveAnimation.duration = 2;
    
    //开演
    [moveLayer addAnimation:moveAnimation forKey:@"moveAnimation"];
}

- (void)initRotateLayer
{
    //演员初始化
    rotateLayer = [[CALayer alloc] init];
    rotateLayer.backgroundColor = [UIColor greenColor].CGColor;
    rotateLayer.frame = CGRectMake(60, 240 , 50, 50);
    rotateLayer.cornerRadius = 10;
    [self.view.layer addSublayer:rotateLayer];
    
    //设定剧本
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:2.0 * M_PI];
    rotateAnimation.autoreverses = YES;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.repeatCount = MAXFLOAT;
    rotateAnimation.duration = 2;
    
    //开演
    [rotateLayer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

- (void)initGroupLayer
{
    //演员初始化
    groupLayer = [[CALayer alloc] init];
    groupLayer.frame = CGRectMake(60, 340+100 , 50, 50);
    groupLayer.cornerRadius = 10;
    groupLayer.backgroundColor = [[UIColor purpleColor] CGColor];
    [self.view.layer addSublayer:groupLayer];
    
    //设定剧本
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 0.8;
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:groupLayer.position];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(320 - 80,
                                                                  groupLayer.position.y)];
    moveAnimation.autoreverses = YES;
    moveAnimation.repeatCount = MAXFLOAT;
    moveAnimation.duration = 2;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:6.0 * M_PI];
    rotateAnimation.autoreverses = YES;
    rotateAnimation.repeatCount = MAXFLOAT;
    rotateAnimation.duration = 2;
    
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.duration = 2;
    groupAnnimation.autoreverses = YES;
    groupAnnimation.animations = @[moveAnimation, scaleAnimation, rotateAnimation];
    groupAnnimation.repeatCount = MAXFLOAT;
    //开演
    [groupLayer addAnimation:groupAnnimation forKey:@"groupAnnimation"];
}

-(void)doTransitionWithType:(UIViewAnimationOptions)animationTransitionType
{
    if ([self.view.subviews containsObject:_view2]) {
        [UIView transitionFromView:_view2 toView:_view1 duration:2.0 options:animationTransitionType completion:^(BOOL finished) {
            [_view2 removeFromSuperview];
        }];
        [self.view addSubview:_view1];
        [self.view sendSubviewToBack:_view1];
        
    }else{
        [UIView transitionFromView:_view1 toView:_view2 duration:2.0 options:animationTransitionType completion:^(BOOL finished) {
            [_view1 removeFromSuperview];
        }];
        [self.view addSubview:_view2];
        [self.view sendSubviewToBack:_view2];
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    }
@end
