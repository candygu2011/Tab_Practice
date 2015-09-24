//
//  GMLCircleView.m
//  ScrollerVC
//
//  Created by hi on 15/9/24.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "GMLCircleView.h"
#define  PI 3.14159265358979323846
@implementation GMLCircleView
static float arcWidth; // 圆弧宽度
static double pieCapacity; // 角度增量值
static inline float radians(double degrees){
    return degrees * PI / 180;
}

-(instancetype)initWithFrame:(CGRect)frame arcWidth:(double)width current:(double)current total:(double)total
{
    self = [super initWithFrame:frame];
    if (self) {
        arcWidth = width;
        pieCapacity = 360 *current/total;
        NSLog(@"pieCapacity->>%f",pieCapacity);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.4);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.4);
    CGContextSetLineWidth(context, 0);
    
    
    // 扇形参数
    double radius; // 半径
    if (self.frame.size.width > self.frame.size.height) {
        radius = self.frame.size.height / 2 - self.frame.size.height / 10;
        
    }else{
        radius = self.frame.size.width / 2 - self.frame.size.width / 10;
    }
    int startX = self.frame.size.width / 2 ; // 圆心x坐标
    int startY = self.frame.size.height / 2 ; // 圆心Y坐标
    double pieStart= 0; // 起始角度
    int clockwise = 1; // 0 = 逆时针，1 顺时针
    
    // 逆时针扇形
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddArc(context, startX, startY, radius, radians(pieStart), radians(pieStart + pieCapacity), clockwise);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    // 画圆
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 227.0/255, 227.0/255, 227.0/255, 1.0);
    CGRect cricle = CGRectInset(self.bounds, arcWidth, arcWidth);
    CGContextAddEllipseInRect(context, cricle);
    CGContextFillPath(context);
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1;
    
}

@end
