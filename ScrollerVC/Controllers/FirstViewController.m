//
//  FirstViewController.m
//  ScrollerVC
//
//  Created by hi on 15/7/16.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "FirstViewController.h"
#import "UIImageView+WebCache.h"
#import "GMLCustomAlterView.h"
@interface FirstViewController ()
//剩余票数
@property(nonatomic,assign) int leftTicketsCount;
@property(nonatomic,strong)NSThread *thread1;
@property(nonatomic,strong)NSThread *thread2;
@property(nonatomic,strong)NSThread *thread3;

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _label.text = @"就只是在测试下autolayout而已啦啦啦啦啦啦啦啦";
    
    /*一、线程锁 */
    //默认有20张票
    
    self.leftTicketsCount=10;
    
    //开启多个线程，模拟售票员售票
    
    self.thread1=[[NSThread alloc]initWithTarget:self selector:@selector(sellTickets) object:nil];
    
    self.thread1.name=@"售票员A";
    
    self.thread2=[[NSThread alloc]initWithTarget:self selector:@selector(sellTickets) object:nil];
    
    self.thread2.name=@"售票员B";
    
    self.thread3=[[NSThread alloc]initWithTarget:self selector:@selector(sellTickets) object:nil];
    self.thread3.name=@"售票员C";
    
    
    
    // 二、 线程通信
    /*
     线程间通信常用方法
     - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
     - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait;
     */
    
    


}

-(void)sellTickets
{
    while (1) {
        /*
         互斥锁(同步锁)的优缺点
         优点：能有效防止因多线程抢夺资源造成的数据安全问题
         缺点：需要消耗大量的CPU资源
         
         互斥锁的使用前提：多条线程抢夺同一块资源
         相关专业术语：线程同步,多条线程按顺序地执行任务
         互斥锁，就是使用了线程同步技术
         
         
         
         原子和非原子属性的选择
         nonatomic和atomic对比
         atomic：线程安全，需要消耗大量的资源
         nonatomic：非线程安全，适合内存小的移动设备
         
         iOS开发的建议
         所有属性都声明为nonatomic
         尽量避免多线程抢夺同一块资源
         尽量将加锁、资源抢夺的业务逻辑交给服务器端处理，减小移动客户端的压力

         
         */
        @synchronized(self) {//只能加一把锁

        //1.先检查票数
        int count=self.leftTicketsCount;
        if (count>0) {
            //暂停一段时间
            [NSThread sleepForTimeInterval:0.002];
            
            //2.票数-1
            self.leftTicketsCount= count-1;
            
            //获取当前线程
            NSThread *current=[NSThread currentThread];
            NSLog(@"%@--卖了一张票，还剩余%d张票",current,self.leftTicketsCount);
        }else
            {
            //退出线程
            [NSThread exit];
            }
        }
    }
}

- (IBAction)synchronizedAction:(id)sender {
    
    //开启线程
    
    [self.thread1 start];
    [self.thread2 start];
    [self.thread3 start];
    
}
/**
 *  下载网络图片  本地显示
 */
- (IBAction)downloadImage:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://pic.tuanche.com/car/20150420/14295244097434751_s.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
     UIImage *image=[UIImage imageWithData:data];
    
    //  返回主线程  更新图片
//    [self performSelector:@selector(upDateLogImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(upDateLogImage:) withObject:image waitUntilDone:NO];
    
    
    
}
// 更新logo图片
-(void)upDateLogImage:(UIImage *)image
{
    self.logoImg.image = image;
}

// GCD 多线程
/*
    CGD是纯C的代码 所以它是函数不是方法
 
 （1）用同步的方式执行任务 dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
 
 参数说明：
 
 queue：队列
 
 block：任务
 
 
 
 （2）用异步的方式执行任务 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
 
 以上两个函数都是将右边的参数（任务）放到左边的参数（队列）中执行

 
 */
- (IBAction)gcdAction:(id)sender {
    
    
    GMLCustomAlterView *alterView = [[GMLCustomAlterView alloc] initWithFrame:self.view.bounds style:GMLCustomAlterViewStyleGlobal];
    
    [alterView showView];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    
}

@end


