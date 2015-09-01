//
//  GMLLocationDetailAddressManager.m
//  ScrollerVC
//
//  Created by hi on 15/8/25.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "GMLLocationDetailAddressManager.h"

@implementation GMLLocationDetailAddressManager
-(void)locationChangedFrom:(CLLocation *)oldLocation toNewLocation:(CLLocation *)newLocation
{
    [self postNotification:newLocation];
}

+(instancetype)shareInstance
{
    static GMLLocationDetailAddressManager *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[GMLLocationDetailAddressManager alloc] init];
    });
    
    return location;
}

@end
