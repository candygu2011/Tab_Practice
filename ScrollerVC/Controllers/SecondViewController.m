//
//  SecondViewController.m
//  ScrollerVC
//
//  Created by hi on 15/7/16.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "SecondViewController.h"
#import "DrawView.h"
#import "GMLCircleView.h"
#import "UIView+Additional.h"
#import "MJRefresh.h"

//颜色与随机颜色
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kARGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface SecondViewController ()
{
}
@property (nonatomic,strong) CALayer *layer;
@property (nonatomic,strong) UIImageView *containerView;
@property (nonatomic,strong) UIScrollView *scrollView;




@end

@implementation SecondViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =  kRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
//    [self dotteLine];
    
//    DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    [self.view addSubview:drawView];
    
//    [self emitterTtest];
    
//    [self drawCircleView];
//    [self.view addSubview:self.scrollView];
//    [self addRefresh];
    
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *createDirPath = @"";
//    [fm createFileAtPath:createDirPath contents:[createDirPath dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
//    [self runAnimateKeyframes];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.containerView = imgView;
//    [self testQuartz2D];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(animationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)animationAction
{
 }

- (void)testQuartz2D
{
    //
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 200), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 100, 100));
    CGContextStrokePath(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    self.containerView.image = image;
    NSData *data=UIImagePNGRepresentation(image);
    [data writeToFile:@"/Users/hi/Desktop/abc.png" atomically:YES];
}


- (void)runAnimateKeyframes {
    
    /**
     *  relativeDuration  动画在什么时候开始
     *  relativeStartTime 动画所持续的时间
     */
    
    [UIView animateKeyframesWithDuration:6.f
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0   // 相对于6秒所开始的时间（第0秒开始动画）
                                                          relativeDuration:1/3.0 // 相对于6秒动画的持续时间（动画持续2秒）
                                                                animations:^{
                                                                    self.view.backgroundColor = [UIColor redColor];
                                                                }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:1/3.0 // 相对于6秒所开始的时间（第2秒开始动画）
                                                          relativeDuration:1/3.0 // 相对于6秒动画的持续时间（动画持续2秒）
                                                                animations:^{
                                                                    self.view.backgroundColor = [UIColor yellowColor];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:2/3.0 // 相对于6秒所开始的时间（第4秒开始动画）
                                                          relativeDuration:1/3.0 // 相对于6秒动画的持续时间（动画持续2秒）
                                                                animations:^{
                                                                    self.view.backgroundColor = [UIColor greenColor];                                                                }];
                                  
                              }
                              completion:^(BOOL finished) {
                                  [self runAnimateKeyframes];
                              }];
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        
    }
    return _scrollView;
}


- (void)addRefresh
{
    [self.scrollView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadDataFreash)];
    self.scrollView.header.updatedTimeHidden = NO;
    NSMutableArray *images = [NSMutableArray array];
    UIImage *imag = [UIImage imageNamed:@"loading1"];
    [images addObject:imag];
    [self.scrollView.gifHeader setImages:images forState:MJRefreshHeaderStateIdle];
    
    NSMutableArray *refreshArr = [NSMutableArray array];
    for (NSInteger i = 1; i <= 2; i++) {
        UIImage *ima = [UIImage imageNamed:[NSString stringWithFormat:@"loading%zd",i]];
        [refreshArr addObject:ima];
    }
    [self.scrollView.gifHeader setImages:refreshArr forState:MJRefreshHeaderStatePulling];
    [self.scrollView.gifHeader setImages:refreshArr forState:MJRefreshHeaderStateRefreshing];
    [self.scrollView.gifHeader beginRefreshing];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] init]] delegate:self startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
}
-(void)loadDataFreash
{
    
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

- (void)drawCircleView
{
    CGRect frame = CGRectMake(0, 50, 400, 400);
    GMLCircleView *circleView = [[GMLCircleView alloc] initWithFrame:frame arcWidth:100 current:1 total:1];
    circleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:circleView];
    NSLog(@"%@",NSStringFromCGPoint(circleView.center));
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    imgView.image = [UIImage imageNamed:@"bg_kefu@2x"];
    imgView.center = CGPointMake(circleView.center.x, circleView.center.y-50);
    [circleView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imgView addGestureRecognizer:tap];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 5;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [tap.view.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    
}
-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration  =  dur;
    animation.autoreverses = NO;
    animation.cumulative = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
    
    return animation;
    
}


@end
