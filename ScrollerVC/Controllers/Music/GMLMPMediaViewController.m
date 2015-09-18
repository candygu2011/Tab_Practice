//
//  GMLMPMediaViewController.m
//  ScrollerVC
//
//  Created by hi on 15/9/18.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "GMLMPMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface GMLMPMediaViewController ()<MPMediaPickerControllerDelegate>
/**
 * 媒体选择器
 */
@property (nonatomic,strong) MPMediaPickerController *mediaPicker;
/**
 *  音乐播放器
 */
@property (nonatomic,strong) MPMusicPlayerController *musicPicker;
@property (nonatomic,strong) MPVolumeView *volumeView ;

@end

@implementation GMLMPMediaViewController
-(void)dealloc
{
    [self.musicPicker endGeneratingPlaybackNotifications];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MPVolumeView *volumeView = [ [MPVolumeView alloc] init];
    volumeView.frame=CGRectMake(47, self.view.bounds.size.height-64-30, 227, 23);
    [volumeView setShowsVolumeSlider:YES];
    [volumeView setShowsRouteButton:YES];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];
    self.volumeView = volumeView;
    
  
}

#pragma mark -- layz --
-(MPMediaPickerController *)mediaPicker
{
    if (!_mediaPicker) {
        _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
        _mediaPicker.allowsPickingMultipleItems = YES; // 允许多选
        _mediaPicker.prompt = @"请选择要播放的音乐";
        _mediaPicker.delegate = self;
        
    }
    return _mediaPicker;
}

-(MPMusicPlayerController *)musicPicker
{
    if (!_musicPicker) {
        _musicPicker = [MPMusicPlayerController systemMusicPlayer]; // 支持后台播放
//        _musicPicker = [MPMusicPlayerController applicationMusicPlayer]; // 不支持后台播放
        [_musicPicker beginGeneratingPlaybackNotifications]; // 开启通知，否则监控不到 MPMusicPlayerController通知
        
        
    }
    return _musicPicker;
}
/**
 *  获取媒体队列
 *
 *  @return 媒体队列
 */
- (MPMediaQuery *)getLocalMediaQuery{
    MPMediaQuery *mediaQueue = [MPMediaQuery songsQuery];
    for (MPMediaItem *item in mediaQueue.items) {
        NSLog(@"title :%@,%@",item.title,item.albumTitle);
    }
    return mediaQueue;
}
/**
 *  获取媒体集合
 *
 *  @return 媒体集合
 */

- (MPMediaItemCollection *)getLocalMediaItemCollection{
    MPMediaQuery *mediaQueue  = [MPMediaQuery songsQuery];
    NSMutableArray *array = [NSMutableArray array];
    for (MPMediaItem *item in mediaQueue.items) {
        [array addObject:item];
        NSLog(@"title  :%@,%@",item.title,item.albumTitle);
    }
    MPMediaItemCollection *mediaItemCollection = [[MPMediaItemCollection alloc] initWithItems:[array copy]];
    return mediaItemCollection;
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    MPMediaItem *mediaItem=[mediaItemCollection.items firstObject];
    NSLog(@"标题：%@,表演者：%@,专辑：%@",mediaItem.title ,mediaItem.artist,mediaItem.albumTitle);
    [self.musicPicker setQueueWithItemCollection:mediaItemCollection];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 通知--
- (void)addNotification{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
//    [notification addObserver:self forKeyPath:@selector(playbackStateChange:) options:<#(NSKeyValueObservingOptions)#> context:<#(void *)#>]
    
    [notification addObserver:self selector:@selector(playbackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPicker];
    
}

- (void)playbackStateChange: (NSNotification *)notification
{
    switch (self.musicPicker.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"playing");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"paused");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"stop");
            break;
        default:
            break;
    }
}

- (IBAction)selectedClick:(id)sender
{
    [self presentViewController:self.mediaPicker animated:YES completion:nil];
}
- (IBAction)playClick:(id)sender {
    [self.musicPicker play];
    
}

- (IBAction)puaseClick:(id)sender {
    [self.musicPicker pause];
}


- (IBAction)stopClick:(id)sender {
    
    [self.musicPicker stop];
}
- (IBAction)nextClick:(id)sender {
    
    [self.musicPicker skipToNextItem];
}
- (IBAction)prevClick:(id)sender {
    [self.musicPicker skipToPreviousItem];
}
- (IBAction)addVolume:(id)sender {
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [self.volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    float systemVolume = volumeViewSlider.value;
    systemVolume += 0.2f;
    NSLog(@"sys = %f",systemVolume);
    [volumeViewSlider setValue:systemVolume animated:NO];
    
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)reduceVolume:(id)sender {
    
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [self.volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    float systemVolume = volumeViewSlider.value;
    NSLog(@"sys = %f",systemVolume);
    systemVolume -= 0.2f;
    [volumeViewSlider setValue:systemVolume animated:NO];
    
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
