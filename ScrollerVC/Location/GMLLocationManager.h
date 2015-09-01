//
//  GMLLocationManager.h
//  ScrollerVC
//
//  Created by hi on 15/8/25.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//location Notification
extern NSString * const GMLLocationManagerUserLocationDidChangeOrFailNotification;
//region Notification
extern NSString * const GMLLocationManagerUserRegionDidChangeOrFailNotification;
//heading Notification
extern NSString * const GMLLocationManagerUserHeadingDidChangeOrFailNotification;

//location Info
extern NSString * const GMLLocationManagerNotificationLocationUserInfoKey;
extern NSString * const GMLLocationManagerNotificationLocationUserInfoKeyOldLocation;
//region Info
extern NSString * const GMLLocationManagerNotificationRegionInfoKey;
extern NSString * const GMLLocationManagerNotificationRegionEnterOrExitKey;
//heading Info
extern NSString * const GMLLocationManagerNotificationHeadingUserInfoKey;
//error Info
extern NSString * const GMLLocationManagerNotificationErrorInfoKey;



@class GMLLocationManager;
@interface GMLLocationManager : NSObject

@property (nonatomic,readonly) CLLocation *location;
@property (nonatomic,copy) NSString *purpose;


@property (nonatomic) CLLocationDistance userDistanceFilter;
@property (nonatomic) CLLocationAccuracy userDesiredAccuracy;
@property (nonatomic) CLLocationDistance regionDistanceFilter;
@property (nonatomic) CLLocationDegrees headingFilter;
@property (nonatomic,readonly) NSSet *regions;

+(GMLLocationManager*)sharedLocationManager;

- (id)initWithUserDistanceFilter:(CLLocationDistance)userDistanceFilter userDesiredAccuracy:(CLLocationAccuracy)userDesiredAccuracy purpose:(NSString *)purpose ;

+ (BOOL)headingServicesAvailable;
+ (BOOL)locationServicesEnabled;
+ (BOOL)regionMonitoringAvailable;
+ (BOOL)regionMonitoringEnabled;
+ (BOOL)significantLocationChangeMonitoringAvailable;

- (void)startUpdatingLocation;
- (void)updateUserLocation;
- (void)stopUpdatingLocation;

//heading will be updated in real time. You need explicitly call stopUpdatingHeading
- (void)startUpdatingHeading;
- (void)stopUpdatingHeading;

- (void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate;
- (void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate withRadius:(CLLocationDistance)radius;
- (void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate withRadius:(CLLocationDistance)radius desiredAccuracy:(CLLocationAccuracy)accuracy;
- (void)addRegionForMonitoring:(CLRegion *)region;
- (void)addRegionForMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy;
- (void)stopMonitoringForRegion:(CLRegion *)region;
- (void)stopMonitoringAllRegions;

@end
