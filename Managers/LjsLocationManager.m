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
#import "NSArray+LjsAdditions.h"


//static const int ddLogLevel = LOG_LEVEL_WARN;

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsLocationManagerNotificationReverseGeocodingResultAvailable = @"com.littlejoysoftware.Reverse Geocoding Result Available Notification";

static NSUInteger LjsLocationManagerLocationScale = 8;

const LjsLocation LjsLocationNotFound = {CGFLOAT_MIN, CGFLOAT_MAX};

CGFloat const LjsLocationDegreesNotFound = CGFLOAT_MIN;

static CGFloat const LjsMinHeading = 0.0;
static CGFloat const LjsMaxHeading = 360.0;
static CGFloat const LjsMinLongitude = -180.0;
static CGFloat const LjsMaxLongitude = 180.0;
static CGFloat const LjsMinLatitude = -90.0;
static CGFloat const LjsMaxLatitude = 90.0;

const CGPoint LjsLatitudeBounds = {LjsMinLatitude, LjsMaxLatitude};
const CGPoint LjsLongitudeBounds = {LjsMinLongitude, LjsMaxLongitude};
const CGPoint LjsHeadingBounds = {LjsMinHeading, LjsMaxHeading};


#ifdef LJS_LOCATION_SERVICES_DEBUG
static NSString *LjsLocationManagerMercury = @"mercury";
static NSString *LjsLocationManagerPluto = @"pluto";
static NSString *LjsLocationManagerNeptune = @"neptune";
#endif

// himmeri strasse
static CGFloat const LjsLatitudeZurich = 47.41909409;
static CGFloat const LjsLongitudeZurich = 8.53678989;

//static CGFloat const LjsLatitudeZurich = 26.9339;
//static CGFloat const LjsLongitudeZurich = -80.0944;


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

+ (BOOL) isValue:(CGFloat) aValue onInterval:(CGPoint) aInterval;

@end


@implementation LjsLocationManager

NSString *NSStringFromLjsLocation(LjsLocation aLocation) {
  CGFloat lat = aLocation.latitude;
  CGFloat lng = aLocation.longitude;
  NSString *latStr = @"NAN", *lngStr = @"NAN";
  if ([LjsLocationManager isValidLatitude:lat]) {
    NSDecimalNumber *dn = [LjsDn dnWithFloat:lat];
    NSDecimalNumber *round = [dn dnByRoundingAsLocation];
    latStr = [round stringValue];
  } 
  
  if ([LjsLocationManager isValidLongitude:lng]) {
    lngStr = [[[LjsDn dnWithFloat:lng] dnByRoundingAsLocation] stringValue];
  }
  return [NSString stringWithFormat:@"(%@, %@)", latStr, lngStr];
}

LjsLocation LjsLocationFromString(NSString *aString) {
#if TARGET_OS_IPHONE
  CGPoint point = CGPointFromString(aString);
#else
  NSPoint point = NSPointFromString(aString);
#endif
  return LjslocationMake(point.x, point.y);
}

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
    
    self.headingBounds = LjsHeadingBounds;
    self.latitudeBounds = LjsLatitudeBounds;
    self.longitudeBounds = LjsLongitudeBounds;
  }
  return self;
}

+ (BOOL) isValue:(CGFloat) aValue onInterval:(CGPoint) aInterval {
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
  if (result == NO) {
    DDLogDebug(@"result was NO, but LJS_LOCATION_SERVICES_SIMULATOR_DEBUG is on - will return YES");
    result = YES;
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
  if (aHeading == LjsLocationDegreesNotFound) {
    return NO;
  } else {
    return [LjsLocationManager isValue:aHeading onInterval:LjsHeadingBounds];
  }
}


+ (BOOL) isValidLatitude:(CGFloat) aLatitude {
  if (aLatitude == LjsLocationDegreesNotFound) {
    return NO;
  } else {
    return [LjsLocationManager isValue:aLatitude onInterval:LjsLatitudeBounds];
  }
}


+ (BOOL) isValidLongitude:(CGFloat) aLongitude {
 if (aLongitude == LjsLocationDegreesNotFound) {
    return NO;
  } else {
    return [LjsLocationManager isValue:aLongitude onInterval:LjsLongitudeBounds];
  }
}


#pragma mark Latitude, Longitude, and Heading

- (CGFloat) longitude {
  CGFloat result;
  if (self.coreLocation == nil) {
    result = LjsLocationDegreesNotFound;
  } else {
    result = self.coreLocation.coordinate.longitude;
  }

#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if (result == LjsLocationDegreesNotFound)  {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
      result = LjsLongitudeZurich;
    } 
  }
#endif
  
#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if (result == LjsLocationDegreesNotFound) {
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
    result = LjsLocationDegreesNotFound;
  } else {
    result = self.coreLocation.coordinate.latitude;
  }
  
#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if (result == LjsLocationDegreesNotFound)  {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
      result = LjsLatitudeZurich;
    } 
  }
#endif
  
#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if (result == LjsLocationDegreesNotFound) {
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
    result = LjsLocationDegreesNotFound;
  } else {
    result = self.coreHeading.trueHeading;
  }

#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if (result == LjsLocationDegreesNotFound) {
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
  if (result == LjsLocationDegreesNotFound) {
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


- (LjsLocation) location {
  CGFloat lat = [self latitude];
  CGFloat lng = [self longitude];
  LjsLocation result = LjslocationMake(lat, lng);
  return result;
}

+ (BOOL) isValidLocation:(LjsLocation) aLocation {
  return ([LjsLocationManager isValidLatitude:aLocation.latitude] &&
          [LjsLocationManager isValidLongitude:aLocation.longitude]);
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
  return [self dnMetersBetweenA:a b:b scale:LjsLocationManagerLocationScale];
}


- (NSDecimalNumber *) dnMetersBetweenA:(LjsLocation) a
                                     b:(LjsLocation) b
                                 scale:(NSUInteger) aScale {
  NSDecimalNumber *result = [LjsDn dnWithFloat:[self metersBetweenA:a b:b]];
  return [result dnByRoundingWithScale:aScale];
}

- (CGFloat) kilometersBetweenA:(LjsLocation) a
                             b:(LjsLocation) b {
  return [self metersBetweenA:a b:b] / 1000.0;
}

- (NSDecimalNumber *) dnKilometersBetweenA:(LjsLocation) a
                                         b:(LjsLocation) b {
  
  return [self dnKilometersBetweenA:a b:b scale:LjsLocationManagerLocationScale];
}

- (NSDecimalNumber *) dnKilometersBetweenA:(LjsLocation) a
                                        b:(LjsLocation) b
                                    scale:(NSUInteger) aScale {
  return [[LjsDn dnWithFloat:[self kilometersBetweenA:a b:b]] 
          dnByRoundingWithScale:aScale];
}

- (CGFloat) feetBetweenA:(LjsLocation) a
                       b:(LjsLocation) b {
  return [self metersBetweenA:a b:b] * 3.2808399;
}

- (NSDecimalNumber *) dnFeetBetweenA:(LjsLocation) a
                                   b:(LjsLocation) b {
  return [self dnFeetBetweenA:a b:b scale:LjsLocationManagerLocationScale];
}

- (NSDecimalNumber *) dnFeetBetweenA:(LjsLocation) a
                                   b:(LjsLocation) b
                               scale:(NSUInteger) aScale {
  return [[LjsDn dnWithFloat:[self feetBetweenA:a b:b]]
          dnByRoundingWithScale:aScale];
}

- (CGFloat) milesBetweenA:(LjsLocation) a
                        b:(LjsLocation) b {
  return [self metersBetweenA:a b:b] /  1609.344;
}

- (NSDecimalNumber *) dnMilesBetweenA:(LjsLocation) a
                                    b:(LjsLocation) b {
  return [self dnMilesBetweenA:a b:b scale:LjsLocationManagerLocationScale];
}

- (NSDecimalNumber *) dnMilesBetweenA:(LjsLocation) a
                                    b:(LjsLocation) b
                                scale:(NSUInteger) aScale {
  return [[LjsDn dnWithFloat:[self milesBetweenA:a b:b]]
          dnByRoundingWithScale:aScale];
}


- (CLLocation *) clLocationWithLocation:(LjsLocation) aLocation {
  CLLocation *result = nil;
  if ([LjsLocationManager isValidLocation:aLocation]) {
    result = [[CLLocation alloc] initWithLatitude:aLocation.latitude
                                        longitude:aLocation.longitude];
  }
  return result;
}


- (LjsLocation) locationWithClLocation:(CLLocation *) aLocation {
  if (aLocation == nil) {
    return LjsLocationNotFound;
  }
  
  LjsLocation location = LjslocationMake(aLocation.coordinate.latitude,
                                         aLocation.coordinate.longitude);
  if ([LjsLocationManager isValidLocation:location] == NO) {
    location = LjsLocationNotFound;
  }
  return location;
}

#pragma mark Reverse Geocoding 

- (void) detailsForLocation:(LjsLocation) aLocation {
#if TARGET_OS_IPHONE
  Class clgeocoder = NSClassFromString(@"CLGeocoder");
  if (clgeocoder != nil) {
    CLLocation *loc = [self clLocationWithLocation:aLocation];
    if (loc != nil) {
      CLGeocoder *coder = [[CLGeocoder alloc] init];
      [coder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
          NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
          [userInfo setObject:NSStringFromLjsLocation(aLocation) forKey:@"sourceLocation"];
          CLPlacemark *mark = [placemarks nth:0];
          LjsLocation foundLoc = [self locationWithClLocation:[mark location]];
          if ([LjsLocationManager isValidLocation:foundLoc]) {
            [userInfo setObject:NSStringFromLjsLocation(foundLoc) forKey:@"foundLocation"];
          }
          NSString *obj;
          if ((obj = mark.name) != nil) [userInfo setObject:obj forKey:@"name"];
          if ((obj = mark.ISOcountryCode) != nil) [userInfo setObject:obj forKey:@"ISOcountryCode"];
          if ((obj = mark.country) != nil) [userInfo setObject:obj forKey:@"country"];
          if ((obj = mark.postalCode) != nil) [userInfo setObject:obj forKey:@"postalCode"];
          if ((obj = mark.administrativeArea) != nil) [userInfo setObject:obj forKey:@"administrativeArea"];
          if ((obj = mark.subAdministrativeArea) != nil) [userInfo setObject:obj forKey:@"subAdministrativeArea"];
          if ((obj = mark.locality) != nil) [userInfo setObject:obj forKey:@"locality"];
          if ((obj = mark.subLocality) != nil) [userInfo setObject:obj forKey:@"subLocality"];
          if ((obj = mark.thoroughfare) != nil) [userInfo setObject:obj forKey:@"thoroughfare"];
          if ((obj = mark.subThoroughfare) != nil) [userInfo setObject:obj forKey:@"subThoroughfare"];
          if ((obj = mark.inlandWater) != nil) [userInfo setObject:obj forKey:@"inlandWater"];
          if ((obj = mark.ocean) != nil) [userInfo setObject:obj forKey:@"ocean"];
          if (mark.region != nil) [userInfo setObject:mark.region forKey:@"region"];
          if (mark.addressDictionary != nil) [userInfo setObject:mark.addressDictionary forKey:@"addressDictionary"];
          if (mark.areasOfInterest != nil) [userInfo setObject:mark.areasOfInterest forKey:@"areasOfInterest"];
          
          NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
          [nc postNotificationName:LjsLocationManagerNotificationReverseGeocodingResultAvailable
                            object:nil
                          userInfo:userInfo];
        }
      }];
    }
  } else {    
    DDLogWarn(@"could not find class CLGeocoder - will reverse geocode with Google API");
    
  }
#else
  DDLogNotice(@"CLGeocoder not available on MacOS - will reverse geocode with Google API"); 
#endif
}




//
//- (void) reverseGeocoder:(MKReverseGeocoder *) didFailWithError:(NSError *) error {
//  
//}
//
//- (void) reverseGeocoder:(MKReverseGeocoder *) didFindPlacemark:(CLPlacemark *) aPlacemark {
//  
//}



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
