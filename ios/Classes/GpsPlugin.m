#import <CoreLocation/CoreLocation.h>
#import "GpsPlugin.h"

@interface GpsPlugin () <CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation GpsPlugin{
    FlutterResult flutterResult;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"top.kikt/gps" binaryMessenger:[registrar messenger]];
    GpsPlugin *instance = [[GpsPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CLLocationManager *locationManager = [CLLocationManager new];
        self.locationManager = locationManager;
    }

    return self;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"gps" isEqualToString:call.method]) {
        [self requestGps:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)requestGps:(FlutterResult)result {
    flutterResult = result;
    if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways
            || CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self requestLocation];
        return;
    } else if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied || CLLocationManager.authorizationStatus == kCLAuthorizationStatusRestricted) {
        [self resultForValue:nil];
        return;
    }
    [self.locationManager requestAlwaysAuthorization];
}

- (void)requestLocation {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}

- (void)resultForValue:(id)obj {
    FlutterResult result = flutterResult;
    flutterResult = nil;
    result(obj);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.locationManager.delegate = nil;
    if (locations.count != 0) {
        CLLocation *location = locations[0];
        NSString *lat = [@(location.coordinate.latitude) stringValue];
        NSString *lng = [@(location.coordinate.longitude) stringValue];
        NSDictionary *dictionary = @{@"lat": lat, @"lng": lng};
        [self resultForValue:dictionary];
    } else {
        [self resultForValue:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self requestLocation];
    } else {
        [self resultForValue:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location error %@", error);
    [self resultForValue:nil];
}

@end
