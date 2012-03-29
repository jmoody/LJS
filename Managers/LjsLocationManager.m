// Copyright 2011 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsLocationManager.h"
#import "LjsValidator.h"
#import "LjsVariates.h"
#import "Lumberjack.h"
#import "LjsDn.h"
#import "NSDecimalNumber+LjsAdditions.h"

static const int ddLogLevel = LOG_LEVEL_WARN;

//#ifdef LOG_CONFIGURATION_DEBUG
//static const int ddLogLevel = LOG_LEVEL_DEBUG;
//#else
//static const int ddLogLevel = LOG_LEVEL_WARN;
//#endif

//CGFloat const LjsLocationManagerLocationHeadingNotFound = CGFLOAT_MIN;

CGFloat const LjsLocationNotFound = CGFLOAT_MIN;

static CGFloat const LjsMinHeading = 0.0;
static CGFloat const LjsMaxHeading = 360.0;
static CGFloat const LjsMinLongitude = -180.0;
static CGFloat const LjsMaxLongitude = 180.0;
static CGFloat const LjsMinLatitude = -90.0;
static CGFloat const LjsMaxLatitude = 90.0;


#ifdef LJS_LOCATION_SERVICES_DEBUG
static NSString *LjsLocationManagerMercury = @"mercury";
static NSString *LjsLocationManagerPluto = @"pluto";
static NSString *LjsLocationManagerNeptune = @"neptune";
#endif

static CGFloat const LjsLongitudeZurich = 42.22;
static CGFloat const LjsLatitudeZurich = 8.32;


static LjsLocationManager *singleton = nil;

@interface LjsLocationManager () 

/** 
 the core location manager
 @warning do not access directly use locationAvailable, longitude, and latitude
 methods */
@property (nonatomic, strong) CLLocationManager *coreLocationManager;
/** 
 the current location
 @warning do not access directly use locationAvailable, longitude, and latitude
 methods */
@property (nonatomic, strong) CLLocation *coreLocation;

/** 
 the current heading
 @warning do not access directly use headingAvailable and heading methods
 methods */
@property (nonatomic, strong) CLHeading *coreHeading;

@property (nonatomic, assign) CGPoint latitudeBounds;
@property (nonatomic, assign) CGPoint longitudeBounds;
@property (nonatomic, assign) CGPoint headingBounds;

- (BOOL) isValue:(CGFloat) aValue onInterval:(CGPoint) aInterval;

@end


@implementation LjsLocationManager

@synthesize coreLocationManager;
@synthesize coreLocation;
@synthesize coreHeading;
@synthesize latitudeBounds;
@synthesize longitudeBounds;
@synthesize headingBounds;

#ifdef LJS_LOCATION_SERVICES_DEBUG
@synthesize debugDevices;
#endif
@synthesize debugLastHeading;

#pragma mark Memory Management

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (id) sharedInstance {
  @synchronized(self) {
    if (singleton == nil)
      singleton = [[super allocWithZone:NULL] init];
  }
  return singleton;
}

+ (id)allocWithZone:(NSZone *)zone {
  return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}


- (id) init {
  self = [super init];
  if (self != nil) {
    self.coreLocationManager = [[CLLocationManager alloc] init];
    self.coreLocationManager.delegate = self;

    self.coreLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

    [self.coreLocationManager startUpdatingLocation];
#if TARGET_OS_IPHONE    
    if ([CLLocationManager headingAvailable]) {
      DDLogDebug(@"heading service available, starting orientation tracking.");
      [self.coreLocationManager startUpdatingHeading];
    } else {
      DDLogDebug(@"heading service unavailable");
    }
#endif

    
#ifdef LJS_LOCATION_SERVICES_DEBUG
    self.debugDevices = [NSArray arrayWithObjects:LjsLocationManagerMercury,
                         LjsLocationManagerPluto, LjsLocationManagerNeptune, nil];
#endif
    
    self.debugLastHeading = [LjsVariates randomDoubleWithMin:0.0 max:360.0];
    
    self.headingBounds = CGPointMake(LjsMinHeading, LjsMaxHeading);
    self.latitudeBounds = CGPointMake(LjsMinLatitude, LjsMaxLatitude);
    self.longitudeBounds = CGPointMake(LjsMinLongitude, LjsMaxLongitude);
  }
  return self;
}

- (BOOL) isValue:(CGFloat) aValue onInterval:(CGPoint) aInterval {
  return (aValue >= aInterval.x && aValue <= aInterval.y);
}



- (BOOL) locationIsAvailable {
  
  BOOL locationServiceEnabled = [CLLocationManager locationServicesEnabled];
  DDLogDebug(@"location service is turned on: %d", locationServiceEnabled);

   /*
   kCLAuthorizationStatusNotDetermined = 0,
   kCLAuthorizationStatusRestricted,
   kCLAuthorizationStatusDenied,
   kCLAuthorizationStatusAuthorized
   } CLAuthorizationStatus;
   */
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  BOOL locationServicesEnabledForThisApp = status == kCLAuthorizationStatusAuthorized;
  DDLogDebug(@"location service enabled for this app: %d", locationServicesEnabledForThisApp);
  
  BOOL locationExists = self.coreLocation != nil;
  DDLogDebug(@"location is = %@", self.coreLocation);

  BOOL result = locationServiceEnabled && locationServicesEnabledForThisApp && locationExists;

#ifdef LJS_LOCATION_SERVICES_DEBUG
  if (result == NO) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      
      DDLogNotice(@"we are using a debug device: %@ and LJS_LOCATION_SERVICES_DEBUG is on so return true.", deviceName);
      result = YES;
    }
  }
#endif
  
#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if (result == NO && locationServiceEnabled == YES) {
    DDLogDebug(@"LJS_LOCATION_SERVICES_SIMULATOR_DEBUG is on - will return YES");
    result = YES;
  } else if (result == NO && locationServiceEnabled == NO) {
    DDLogNotice(@"declining to override returning NO even though LJS_LOCATION_SERVICES_SIMULATOR_DEBUG is defined - turn on location services in the Settings.app");
  }
#endif
  return result;
}


- (BOOL) headingIsAvailable {
  BOOL serviceAvailable = [CLLocationManager headingAvailable];
  
#ifdef LJS_LOCATION_SERVICES_DEBUG
  if (serviceAvailable == NO) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"we are using a debug device: %@ and LJS_LOCATION_SERVICES_DEBUG is on so return true.", deviceName);
      serviceAvailable = YES;
    }
  }
#endif
  return serviceAvailable;
}


+ (BOOL) isValidHeading:(CGFloat) aHeading {
  if (aHeading == LjsLocationNotFound) {
    return NO;
  } else {
    LjsLocationManager *lm = [LjsLocationManager sharedInstance];
    return [lm isValue:aHeading onInterval:lm.headingBounds];
  }
}


+ (BOOL) isValidLatitude:(CGFloat) aLatitude {
  if (aLatitude == LjsLocationNotFound) {
    return NO;
  } else {
    LjsLocationManager *lm = [LjsLocationManager sharedInstance];
    return [lm isValue:aLatitude onInterval:lm.latitudeBounds];
  }
}


+ (BOOL) isValidLongitude:(CGFloat) aLongitude {
  if (aLongitude == LjsLocationNotFound) {
    return NO;
  } else {
    LjsLocationManager *lm = [LjsLocationManager sharedInstance];
    return [lm isValue:aLongitude onInterval:lm.longitudeBounds];
  }
}


#pragma mark Latitude, Longitude, and Heading

- (CGFloat) longitude {
  CGFloat result;
  if (self.coreLocation == nil) {
    result = LjsLocationNotFound;
  } else {
    result = self.coreLocation.coordinate.longitude;
  }

#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if (result == LjsLocationNotFound)  {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
      result = LjsLongitudeZurich;
    } 
  }
#endif
  
#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if (result == LjsLocationNotFound) {
    DDLogNotice(@"location is not available on the simulator - overriding");
    result = LjsLongitudeZurich;
  }
#endif
  
  return result;
}

- (NSDecimalNumber *) longitudeDn {
  return [[LjsDn dnWithFloat:[self longitude]] dnByRoundingAsLocation];
}

- (CGFloat) latitude {
  CGFloat result;
  if (self.coreLocation == nil) {
    result = LjsLocationNotFound;
  } else {
    result = self.coreLocation.coordinate.latitude;
  }
  
#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if (result == LjsLocationNotFound)  {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
      result = LjsLatitudeZurich;
    } 
  }
#endif
  
#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if (result == LjsLocationNotFound) {
    DDLogNotice(@"location is not available on the simulator - overriding");
    result = LjsLatitudeZurich;
  }
#endif

  return result;
}


- (NSDecimalNumber *) latitudeDn {
  return [[LjsDn dnWithFloat:[self latitude]] dnByRoundingAsLocation];
}

- (CGFloat) trueHeading {
  CGFloat result;
  if (self.coreHeading == nil) {
    result = LjsLocationNotFound;
  } else {
    result = self.coreHeading.trueHeading;
  }

#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if (result == LjsLocationNotFound) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"heading is not available for device: %@ - overriding", deviceName);
      CGFloat random = [LjsVariates randomDoubleWithMin:5.0 max:10.0];
      CGFloat current = self.debugLastHeading;
      self.debugLastHeading = MIN(current + random, LjsMaxHeading);
      result = self.debugLastHeading;
    } 
  }
#endif

#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if (result == LjsLocationNotFound) {
    DDLogNotice(@"heading is not available for simulator - overriding");
    CGFloat random = [LjsVariates randomDoubleWithMin:5.0 max:10.0];
    NSUInteger signedness = [LjsVariates flip];
    if (signedness == 0) {
      random = random * -1.0;
    }
    CGFloat current = self.debugLastHeading;
    CGFloat new = MIN(current + random, LjsMaxHeading);
    self.debugLastHeading = MAX(new, LjsMinHeading);      
    result = self.debugLastHeading;
  }
#endif
  return result;
}

- (NSDecimalNumber *) trueHeadingDn {
  return [[LjsDn dnWithFloat:[self trueHeading]] dnByRoundingAsLocation];
}

- (CGFloat) metersBetweenA:(LjsLocation) a
                         b:(LjsLocation) b {
  CLLocation *lA = [[CLLocation alloc] initWithLatitude:a.latitude
                                              longitude:a.longitude];
  CLLocation *lB = [[CLLocation alloc] initWithLatitude:b.latitude
                                              longitude:b.longitude];
  return (CGFloat)[lA distanceFromLocation:lB];
}

- (NSDecimalNumber *) dnMetersBetweenA:(LjsLocation) a
                           b:(LjsLocation) b {
  return [self dnMetersBetweenA:a b:b scale:5];
}


- (NSDecimalNumber *) dnMetersBetweenA:(LjsLocation) a
                                     b:(LjsLocation) b
                                 scale:(NSUInteger) aScale {
  NSDecimalNumber *result = [LjsDn dnWithFloat:[self metersBetweenA:a b:b]];
  return [result dnByRoundingWithScale:aScale];
}






#pragma mark CLLocationManagerDelegate 

/** @name CLLocationManagerDelegate implementation */

/**
 Sets the `self.coreLocation` ivar to the new location.
 
 @param manager The location manager object that generated the update event.
 @param newLocation The new location data.
 @param oldLocation The location data from the previous update. If this is the 
 first update event delivered by this location manager, this parameter is nil.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  DDLogDebug(@"received a new location: %@", newLocation);
  if (newLocation == nil) {
    DDLogDebug(@"got null location, keep the old location: %@", self.coreLocation);
  } else {
    DDLogDebug(@"updating location");
    self.coreLocation = newLocation;
  }
}

/**
 handles location manager update errors
 
 @param manager The location manager object that was unable to retrieve the location.
 @param error The error object containing the reason the location or heading could 
 not be retrieved.
*/
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  DDLogError(@"failed to get location: %@ %@ %d", [error domain], [error localizedDescription], 
             [error code]);
}

/**
 Asks the delegate whether the heading calibration alert should be displayed.
 
 Almost always we want to return NO.
 */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
  return NO;
}

/**
 Sets the self.coreHeading ivar.
 @param manager The location manager object that generated the update event.
 @param newHeading The new heading data.
*/
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  self.coreHeading = newHeading;
}


@end
