//
//  GMLLocation.m
//  ScrollerVC
//
//  Created by hi on 15/8/25.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "GMLLocation.h"
#import "GMLLocationManager.h"
#import "NSDictionary+Additional.h"

@interface GMLLocation ()
{
    BOOL isAddObserver;
}
@end
@implementation GMLLocation


-(void)addObserverLocation
{
    if (isAddObserver) {
        return;
    }
    isAddObserver = TRUE;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:GMLLocationManagerUserHeadingDidChangeOrFailNotification object:nil];
    
}

-(void)removeObserverLocation
{
    if(!isAddObserver)
        return;
    NSLog(@"");
    isAddObserver = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc
{
    [self removeObserverLocation];
}

#pragma mark 地理位置改变回调
- (void)locationChanged:(NSNotification *)note
{
    //暂时不太好区分定位多次返回的情况，考虑用时间，距离或者第一次返回无效3种方式
    NSDictionary* userInfo = note.userInfo;
    NSError* error = [userInfo getObjectForKey:GMLLocationManagerNotificationErrorInfoKey defaultValue:nil];
    if(error)
    {
        [self postErrorNotification:error];
        NSLog(@"定位失败");
        return;
    }
    
    //定位成功，获取到newLocation和oldLocation
    CLLocation* newLocation = (CLLocation*)[userInfo getObjectForKey:GMLLocationManagerNotificationLocationUserInfoKey defaultValue:nil];
    CLLocation* oldLocation = (CLLocation*)[userInfo getObjectForKey:GMLLocationManagerNotificationLocationUserInfoKey defaultValue:nil];
    
    if(newLocation == nil){
        NSLog(@"ERROR: newLocation == nil");
        return;
    }
    [self locationChangedFrom:oldLocation toNewLocation:newLocation];
}

#pragma mark 抛出通知相关custom方法
//抛出正常通知，携带正常object对象到object
-(void)postNotification:(NSObject*)object
{
    [self postNotification:object userInfo:nil];
}

//抛出错误通知，携带error对象到object
-(void)postErrorNotification:(NSError*)error
{
    [self postNotification:error userInfo:nil];
}

//抛出通知名字：kLocationAddressChangeNotification
-(void)postNotification:(NSObject*)object userInfo:(NSDictionary*)userInfo
{
    NSString* locationName = [self notificationName];
    if(locationName.length == 0){
        NSLog(@"ERROR: notificationName == nil");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:locationName
                                                        object:object
                                                      userInfo:userInfo];
}


+(void)reObtainLocation
{
    [[GMLLocationManager sharedLocationManager] stopUpdatingLocation];
    [[GMLLocationManager sharedLocationManager] startUpdatingLocation];
}

+(void)reObtainLocationOnce
{
    [[GMLLocationManager sharedLocationManager] stopUpdatingLocation];
    [[GMLLocationManager sharedLocationManager] updateUserLocation];
}

#pragma mark 派生类负责实现
-(NSString*)notificationName
{
    return nil;
}

-(void)locationChangedFrom:(CLLocation *)oldLocation toNewLocation:(CLLocation *)newLocation
{
    
}

@end
