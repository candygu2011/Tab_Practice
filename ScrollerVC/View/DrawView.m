//
//  DrawView.m
//  ScrollerVC
//
//  Created by hi on 15/9/14.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "DrawView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation DrawView

-(void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
//    
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 0, 150);
//    CGContextAddLineToPoint(context, 50, 180);
//    CGContextStrokePath(context);
}

-(void)drawOneLineContext:(CGContextRef)context
{
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    CGContextMoveToPoint(context, 20, 20);
    CGContextAddLineToPoint(context, 200, 20);
    CGContextStrokePath(context);
}

-(void)drawWorldsContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.7, 1.0);
    UIFont *font = [UIFont systemFontOfSize:18];
    NSString *title = @"iOS程序猿";
    NSDictionary *dic = @{NSFontAttributeName:font};
    [title drawInRect:CGRectMake(20, 40, 280, 300) withAttributes:dic];
}

-(void)drawSquareContext:(CGContextRef)context
{
    CGContextSetRGBStrokeColor(context, 0, 0.25, 0, 1);
    CGContextFillRect(context, CGRectMake(20, 20, 200, 100));
    CGContextStrokePath(context);
}

@end
