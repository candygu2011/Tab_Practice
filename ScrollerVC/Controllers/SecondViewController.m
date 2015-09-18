//
//  SecondViewController.m
//  ScrollerVC
//
//  Created by hi on 15/7/16.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "SecondViewController.h"
#import "DrawView.h"

//颜色与随机颜色
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kARGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface SecondViewController ()
@property (nonatomic,strong) CALayer *layer;
@property (nonatomic,strong) UIView *containerView;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =  kRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
//    [self dotteLine];
    
//    DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    [self.view addSubview:drawView];
    
//    [self emitterTtest];
}
/**
 *  火焰效果
 */
-(void)emitterTtest
{
    UIView *layer = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:layer];
    self.containerView = layer;
    
    //create particle emitter layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.layer.bounds;
    [self.containerView.layer addSublayer:emitter];
    //configure emitter
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"4@2x"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0; //  生命周期
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4; // 透明度每过一秒就是减少0.4
    cell.velocity = 50; // 运动速度
    cell.velocityRange = 50;
    cell.emissionRange = M_PI_4 ; // 属性的变化范围
    //add particle template to emitter
    emitter.emitterCells = @[cell];
}

- (void)anchorPointTest
{
    // anchorPoint  支撑点 用以支撑动画的转换变化的支点
    // 支点 造就了图形不同的旋转形态
    //anchorPoint 取值（0，1）
    // position 就是 anchorPoint相对于父视图的位置
    // anchorPoint的默认值为(0.5,0.5)，也就是anchorPoint默认在layer的中心点
    //创建图层
    CALayer *mylayer=[CALayer layer];
    //设置图层属性
    mylayer.backgroundColor=[UIColor brownColor].CGColor;
    mylayer.bounds=CGRectMake(0, 0, 150, 100);
    //显示位置
    mylayer.position=CGPointMake(100, 100);
    mylayer.anchorPoint=CGPointZero;
    mylayer.cornerRadius=20;
    //添加图层
    [self.view.layer addSublayer:mylayer];
    self.layer=mylayer;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.layer.anchorPoint = CGPointMake(20, 90);
    NSLog(@"%@ -- %@",NSStringFromCGPoint(self.layer.position),NSStringFromCGPoint(self.layer.anchorPoint));

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
