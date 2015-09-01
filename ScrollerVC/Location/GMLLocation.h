//
//  GMLLocation.h
//  ScrollerVC
//
//  Created by hi on 15/8/25.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>

/**
 *kLocationAddressChangeNotification
 *失败:读取通知的object为NSError对象。
 *成功:ojbect为字符串对象，里面存储着具体的位置地址
 */
@interface GMLLocation : NSObject

+(instancetype)shareInstance;
/*
 * 一直获取位置，只要位置改变，就会有通知。
 */
+ (void)reObtainLocation;


/*
 *只获取一次位置，获取完毕后关闭定位
 */
+ (void)reObtainLocationOnce;

/*
 *@brief 派生类负责return通知名字
 */
-(NSString*)notificationName;


/*
 *@brief 派生类负责对old和newLocation进行操作。基类默认抛出object为newLocation的通知。
 */
-(void)locationChangedFrom:(CLLocation*)oldLocation toNewLocation:(CLLocation*)newLocation;
-(void)addObserverLocation;
-(void)removeObserverLocation;


#pragma mark 抛出通知相关custom方法
-(void)postNotification:(NSObject*)object;
-(void)postErrorNotification:(NSError*)error;
-(void)postNotification:(NSObject*)object userInfo:(NSDictionary*)userInfo;
@end
