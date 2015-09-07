//
//  ScrollViewController.m
//  ScrollerVC
//
//  Created by hi on 15/9/7.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "ScrollViewController.h"
#import "SimpleAudioEngine.h"


@interface ScrollViewController ()<UIScrollViewDelegate>
{
    float parallaxNum[100];

}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sc.delegate = self;
    sc.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:sc];
    _scrollView = sc;
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"TroubleMaker.mp3"];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];
    
    
    for (int i=0;i<_labels.count;i++) {
        float randomFloat=arc4random()%30;
        randomFloat=randomFloat/10;
        parallaxNum[i]=randomFloat;
        
    }

    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat previousX=0;
    
    
    for (int i=0; i<_labels.count; i++) {
        CGFloat diff=(scrollView.contentOffset.x-previousX)* parallaxNum[i];
        UILabel *label=_labels[i];
        
        [label setCenter:CGPointMake(label.center.x-diff, label.center.y)];
    }
    
    
    
    previousX=scrollView.contentOffset.x;
}




@end
