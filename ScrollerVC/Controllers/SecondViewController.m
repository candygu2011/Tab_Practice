//
//  SecondViewController.m
//  ScrollerVC
//
//  Created by hi on 15/7/16.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "SecondViewController.h"
//颜色与随机颜色
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kARGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =  kRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
//    [self dotteLine];

}


-(void)dotteLine
{
    /*
     *画虚线
     */
    CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
    [dotteShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [dotteShapeLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
    dotteShapeLayer.lineWidth = 2.0f ;
    NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
    [dotteShapeLayer setLineDashPattern:dotteShapeArr];
    CGPathMoveToPoint(dotteShapePath, NULL, [UIScreen mainScreen].bounds.size.width*0.5,0);
//    CGPathAddLineToPoint(dotteShapePath, NULL, 20, 285);
    CGPathAddLineToPoint(dotteShapePath, NULL, [UIScreen mainScreen].bounds.size.width*0.5,[UIScreen mainScreen].bounds.size.height);
    [dotteShapeLayer setPath:dotteShapePath];
    CGPathRelease(dotteShapePath);
    [self.view.layer addSublayer:dotteShapeLayer];
    
}

@end
