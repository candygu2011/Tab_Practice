//
//  AVCaptureDeviceViewController.m
//  ScrollerVC
//
//  Created by hi on 15/8/12.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "AVCaptureDeviceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Extension.h"
#import "UIView+Additional.h"
#define kMainScreenWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kMainScreenHeight   ([UIScreen mainScreen].applicationFrame).size.height //应用程序的高度

#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define kMainBoundsWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度

@interface AVCaptureDeviceViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    UIImageView *boundView;
    NSTimer * timer;
    BOOL upOrdown;
    int num;
    

}
@property (nonatomic, retain) UIImageView * line;



@end

@implementation AVCaptureDeviceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];

}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(-10, -5+2*num, _line.size.width, _line.size.height);
        if (2*num == 220) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(-10, -5+2*num, _line.size.width, _line.size.height);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setUpAVCaptureDevice];
    
    [self setupScanRange];
 

}

-(void)setupScanRange
{
    UIImage *boundImg = [UIImage imageNamed:@"qr_bg_bound.png"];// (@"qr_bg_bound.png");
    UIImage *insideImg = [UIImage imageNamed:@"qr_bg_inside.png"];
    CGRect boundRect = CGRectMake((kMainScreenWidth-boundImg.size.width)/2, (kMainScreenHeight-44-boundImg.size.height)/2 ,boundImg.size.width ,boundImg.size.height);
    // 构造边界视图
    UIView *upView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, boundRect.origin.y)];
    upView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qr_bg_out.png"]];
    [self.view addSubview:upView];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, upView.bottom, (kMainScreenWidth-boundRect.size.width)/2, boundRect.size.height)];
    leftView.image = [[UIImage imageNamed:@"qr_bg_in2.png"]  stretchableImageWithLeftCapWidth:300 topCapHeight:10];
    [self.view addSubview:leftView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, upView.bottom, (kMainScreenWidth-boundRect.size.width)/2, boundRect.size.height)];
    rightView.image = [[UIImage imageNamed:@"qr_bg_in2.png"]  stretchableImageWithLeftCapWidth:300 topCapHeight:10];
    [self.view addSubview:rightView];
    rightView.right = kMainScreenWidth;
    
    UIView *otherView = [[UIImageView alloc] initWithFrame:CGRectMake(0, leftView.bottom, kMainScreenWidth, kMainScreenHeight-boundRect.size.height)];
    otherView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qr_bg_out.png"]];
    [self.view addSubview:otherView];
    
    //扫描边框
    boundView = [[UIImageView alloc]initWithFrame:boundRect];
    boundView.image = boundImg;
    [self.view addSubview:boundView];
    
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(-10, -5, insideImg.size.width,insideImg.size.height)];
    _line.image = insideImg;
    [boundView addSubview:_line];
}

-(void)setUpAVCaptureDevice
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input =  [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    [session addInput:input];
    [session addOutput:output];
    
    // 设置扫码格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
   // 设置扫码范围
    UIImage *boundImg = [UIImage imageNamed:@"qr_bg_bound.png"];
    CGFloat imgWidth = boundImg.size.width;
    output.rectOfInterest =CGRectMake ( (( kMainBoundsHeight - imgWidth - 64)/ 2) / (kMainBoundsHeight ) ,(( kMainBoundsWidth - imgWidth )/ 2 )/ kMainBoundsWidth , imgWidth / (kMainBoundsHeight ) , imgWidth / kMainBoundsWidth );
    
    NSLog(@" 扫码范围== %@",NSStringFromCGRect(output.rectOfInterest));

    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    }
}



@end
