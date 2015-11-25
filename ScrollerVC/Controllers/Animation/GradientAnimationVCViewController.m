//
//  GradientAnimationVCViewController.m
//  ScrollerVC
//
//  Created by hi on 15/11/25.
//  Copyright © 2015年 GML. All rights reserved.
//

#import "GradientAnimationVCViewController.h"


@interface GradientAnimationVCViewController ()
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation GradientAnimationVCViewController

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.bounds = CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
    
    
    self.gradientLayer.position = CGPointMake(self.backgroundView.frame.size.width * 0.5, self.backgroundView.frame.size.height * 0.5);
    
    
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    
    
    self.gradientLayer.endPoint = CGPointMake( 1, 0.5);
    
    
    self.gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,
                                  (__bridge id)[UIColor whiteColor].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor];// [[UIColor blackColor].CGColor,[UIColor whiteColor].CGColor,[UIColor blackColor].CGColor];
    
    
    self.gradientLayer.locations = @[@(0.2), @(0.5), @(0.8)];
    
    [self.backgroundView.layer addSublayer:self.gradientLayer];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.textLabel.text = @"CandyGu";
    self.gradientLayer.mask = self.textLabel.layer;

    [self gradientAnimation];
    
}

- (void)gradientAnimation
{
    CABasicAnimation *gradient = [CABasicAnimation animationWithKeyPath:@"locations"];
    gradient.fromValue = @[@(0),@(0),@(0.25)];
    gradient.toValue = @[@(0.75),@(1),@(1)];
    gradient.duration = 2.5;
    gradient.repeatCount = MAXFLOAT;
    [self.gradientLayer addAnimation:gradient forKey:nil];
    
}




- (void)delaySecond:(double)second completion:(void(^)())completion
{
    dispatch_time_t intercalTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_MSEC);
    dispatch_after(intercalTime, dispatch_get_main_queue(), ^{
        completion();
    });
}

@end
