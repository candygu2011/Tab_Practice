//
//  AnimationPracticeViewController.m
//  ScrollerVC
//
//  Created by hi on 15/10/10.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "AnimationPracticeViewController.h"

@interface AnimationPracticeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *devtalkingLabel;

@end

@implementation AnimationPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self animationPractice];
}


-(void)animationPractice
{
    [UIView animateWithDuration:1 animations:^{
        self.devtalkingLabel.transform = CGAffineTransformMakeScale(1.0, 0.5);
        
    }];
}




@end
