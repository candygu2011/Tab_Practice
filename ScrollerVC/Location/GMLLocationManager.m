//
//  GMLLocationManager.m
//  ScrollerVC
//
//  Created by hi on 15/8/25.
//  Copyright (c) 2015年 GML. All rights reserved.
//

#import "GMLLocationManager.h"
#define kDefaultUserDistanceFilter      100
#define kDefaultUserDesiredAccuracy     kCLLocationAccuracyNearestTenMeters
#define kDefaultHeadingFilter           8
#define kDefaultRegionDesiredAccuracy   kCLLocationAccuracyBest
#define kDefaultRegionRadiusDistance    500

//location Notification
NSString * const GMLLocationManagerUserLocationDidChangeOrFailNotification = @"GMLLocationManagerUserLocationDidChangeNotification";
//region Notification
NSString * const GMLLocationManagerUserRegionDidChangeOrFailNotification = @"GMLLocationManagerUserRegionDidChangeNotification";
//heading Notification
NSString * const GMLLocationManagerUserHeadingDidChangeOrFailNotification = @"GMLLocationManagerUserHeadingDidChangeNotification";

//location Info
NSString * const GMLLocationManagerNotificationLocationUserInfoKey = @"kNewLocationKey";
NSString * const GMLLocationManagerNotificationLocationUserInfoKeyOldLocation = @"kOldLocationKey";
//region Info
NSString * const GMLLocationManagerNotificationRegionInfoKey = @"kRegionInfo";
NSString * const GMLLocationManagerNotificationRegionEnterOrExitKey = @"kRegionEnterOrExit";
//heading Info
NSString * const GMLLocationManagerNotificationHeadingUserInfoKey = @"kNewHeadingKey";

//error Info
NSString * const GMLLocationManagerNotificationErrorInfoKey = @"kErrorKey";


@interface GMLLocationManager()<CLLocationManagerDelegate>
{
    BOOL _isUpdatingUserLocation;
    BOOL _isOnlyOneRefresh;
    CLLocationManager *_userLocationManager;
    CLLocationManager *_regionLocationManager;
}

- (void)_init;
- (void)_addRegionForMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy;
@end


@implementation GMLLocationManager

- (void)_addRegionForMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy
{
    NSSet *regions = _regionLocationManager.monitoredRegions;
    
    [_regionLocationManager startMonitoringForRegion:region desiredAccuracy:accuracy];
    
}
+(GMLLocationManager *)sharedLocationManager
{
    static GMLLocationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GMLLocationManager alloc] init];
    });
    return _sharedManager;
}

-(id)initWithUserDistanceFilter:(CLLocationDistance)userDistanceFilter userDesiredAccuracy:(CLLocationAccuracy)userDesiredAccuracy purpose:(NSString *)purpose
{
    NSLog(@"[%@] init:", NSStringFromClass([self class]));
    
    if (self = [super init]) {
        [self _init];
        _userLocationManager.desiredAccuracy = userDesiredAccuracy;
        _userLocationManager.distanceFilter = userDistanceFilter;
        _purpose = purpose;
    }
    return self;
    
}

-(void)_init
{
    NSLog(@"[%@] _init:", NSStringFromClass([self class]));
    _isUpdatingUserLocation = NO;
    _isOnlyOneRefresh = NO;
    
    _userLocationManager = [[CLLocationManager alloc] init];
    _userLocationManager.distanceFilter = kDefaultUserDistanceFilter;
    _userLocationManager.desiredAccuracy = kDefaultUserDesiredAccuracy;
    _userLocationManager.headingFilter = kDefaultHeadingFilter;
    _userLocationManager.delegate = self;
    
    _regionLocationManager = [[CLLocationManager alloc] init];
    _regionLocationManager.distanceFilter = kDefaultUserDistanceFilter;
    _regionLocationManager.desiredAccuracy = kDefaultUserDesiredAccuracy;
    _regionLocationManager.delegate = self;
    
}

-(void)startUpdatingLocation
{
    _isUpdatingUserLocation = YES;
    [_userLocationManager startUpdatingLocation];
}
-(void)updateUserLocation
{
    if (!_isOnlyOneRefresh) {
        _isOnlyOneRefresh = YES;
        [_userLocationManager startUpdatingLocation];
    }
}
-(void)stopUpdatingLocation
{
    _isUpdatingUserLocation = NO;
    [_userLocationManager stopUpdatingLocation];
}

- (void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate withRadius:(CLLocationDistance)radius
{
    [self addCoordinateForMonitoring:coordinate withRadius:radius desiredAccuracy:kDefaultRegionDesiredAccuracy];
}
#pragma mark -- heading --
-(void)startUpdatingHeading
{
    if ([CLLocationManager headingAvailable]) {
        
        [_userLocationManager startUpdatingHeading];
    }
}
-(void)stopUpdatingHeading
{
    [_userLocationManager stopUpdatingHeading];
}


-(void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate
{
     [self addCoordinateForMonitoring:coordinate withRadius:kDefaultRegionRadiusDistance desiredAccuracy:kDefaultRegionDesiredAccuracy];
}

- (void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate withRadius:(CLLocationDistance)radius desiredAccuracy:(CLLocationAccuracy)accuracy
{
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coordinate radius:radius identifier:[NSString stringWithFormat:@"Region with center (%f, %f) and radius (%f)", coordinate.latitude, coordinate.longitude, radius]];
    [self addRegionForMonitoring:region desiredAccuracy:accuracy];
}
- (void)addRegionForMonitoring:(CLRegion *)region
{
    [self addRegionForMonitoring:region desiredAccuracy:kDefaultRegionDesiredAccuracy];

}

- (void)addRegionForMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy {
    
    if (![self isMonitoringThisRegion:region]) {
        [self _addRegionForMonitoring:region desiredAccuracy:accuracy];
    }
}

- (void)stopMonitoringForRegion:(CLRegion *)region {
    
    [_regionLocationManager stopMonitoringForRegion:region];
}

- (void)stopMonitoringAllRegions {
    NSSet *regions = _regionLocationManager.monitoredRegions;
    
    for (CLRegion *reg in regions) {
        [_regionLocationManager stopMonitoringForRegion:reg];
    }
}
- (BOOL)isMonitoringThisRegion:(CLRegion *)region
{
    NSSet *regions = _regionLocationManager.monitoredRegions;
    for (CLRegion *reg in regions) {
        if ([self region:region inRegion:reg ]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)region:(CLRegion *)region inRegion:(CLRegion *)otherRegion
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:otherRegion.center.latitude longitude:otherRegion.center.longitude];
    if ([region containsCoordinate:otherRegion.center] ||   [otherRegion containsCoordinate:region.center]) {
        if ([location distanceFromLocation:otherLocation] + region.radius <= otherRegion.radius) {
            return YES;
        }else if ([location distanceFromLocation:otherLocation] + otherRegion.radius <= region.radius){
            return NO;
        }
    }
    return NO;
}


+(BOOL)headingServicesAvailable
{
    return [CLLocationManager headingAvailable];
}

+(BOOL)locationServicesEnabled
{
    return [CLLocationManager locationServicesEnabled];
}

+(BOOL)regionMonitoringAvailable
{
    return [CLLocationManager  isMonitoringAvailableForClass:self];
}
+ (BOOL)regionMonitoringEnabled
{    
    return [CLLocationManager regionMonitoringEnabled];
}
+ (BOOL)significantLocationChangeMonitoringAvailable
{
    return [CLLocationManager significantLocationChangeMonitoringAvailable];
}




@end
