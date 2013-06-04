// Copyright 2011 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
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
#import "LjsVariates.h"
#import "Lumberjack.h"
#import "LjsValidator.h"
#import "NSDecimalNumber+LjsAdditions.h"
#import "NSArray+LjsAdditions.h"


static const int ddLogLevel = LOG_LEVEL_WARN;

//#ifdef LOG_CONFIGURATION_DEBUG
//static const int ddLogLevel = LOG_LEVEL_DEBUG;
//#else
//static const int ddLogLevel = LOG_LEVEL_WARN;
//#endif

NSString *LjsLocationManagerNotificationReverseGeocodingResultAvailable = @"com.littlejoysoftware.Reverse Geocoding Result Available Notification";
static NSUInteger LjsLocationManagerLocationScale = 8;

static CGFloat const LjsMinHeading = 0.0;
static CGFloat const LjsMaxHeading = 360.0;

//static CGFloat const LjsMinLongitude = -180.0;
//static CGFloat const LjsMaxLongitude = 180.0;
//static CGFloat const LjsMinLatitude = -90.0;
//static CGFloat const LjsMaxLatitude = 90.0;

#ifdef LJS_LOCATION_SERVICES_DEBUG
static NSString *LjsLocationManagerMercury = @"mercury";
static NSString *LjsLocationManagerPluto = @"pluto";
static NSString *LjsLocationManagerNeptune = @"neptune";
#endif

// apple CLGeocoder appears to give back 8 decimal places
// google reverse geocoder appears to give back a max of 6 or 7
// we will round to 8 decimal places
// -         sign     lat: north/south of equator lon: east/west of greenwich
// 0     
// 4          10s      contentient/ocean    ~1000 km
// 7           1s      large state/country  ~ 111 km
// .
// 4        10ths    large city             ~  11 km
// 1       100ths    village                ~ 1.1 km
// 9      1000ths    campus/field            ~ 110 m
// 0     10000ths    parcel of land          ~  11 m  (uncorrected GPS unit with no interference) 
// 9    100000ths    trees                   ~ 1.1 m  (commerical GPS unit with differential correction)
// 4   1000000ths    architectural detals    ~ .11 m  (painstaking GPS measurements)

// himmeri strasse
// this is what apple returned to me from a search
static CGFloat const LjsLatitudeZurich = (CGFloat)47.41909409;
static CGFloat const LjsLongitudeZurich = (CGFloat)8.53678989;

@implementation LjsLocation 
@synthesize latitude;
@synthesize longitude;
@synthesize scale;

static NSString *LjsLocation_LATITUDE_KEY = @"latitude";
static NSString *LjsLocation_LONGITUDE_KEY = @"longitude";
static NSString *LjsLocation_SCALE_KEY = @"scale";


+ (NSUInteger) scale100km {
  return 0;
}

+ (NSUInteger) scale10km {
  return 1;
}

+ (NSUInteger) scale1km {
  return 2;
}

+ (NSUInteger) scale100m {
  return 3;
}

+ (NSUInteger) scale10m {
  return 4;
}

+ (NSUInteger) scale1m {
  return 5;
}


- (void) encodeWithCoder: (NSCoder *)encoder {
  [encoder encodeObject: latitude forKey: LjsLocation_LATITUDE_KEY];
  [encoder encodeObject: longitude forKey: LjsLocation_LONGITUDE_KEY];
  [encoder encodeInteger: scale forKey: LjsLocation_SCALE_KEY];
}

- (id) initWithCoder: (NSCoder *)decoder {
  self = [super init];
  if (self) {
    latitude = [decoder decodeObjectForKey: LjsLocation_LATITUDE_KEY];
    longitude = [decoder decodeObjectForKey: LjsLocation_LONGITUDE_KEY];
    scale = [decoder decodeIntegerForKey: LjsLocation_SCALE_KEY];
  }
  return self;
}

- (id) initWithPoint:(CGPoint) aPoint {
  return [self initWithLatitudeFloat:aPoint.x longitudeFloat:aPoint.y];
}

- (id) initWithLatitudeNumber:(NSNumber *) aLatitude
              longitudeNumber:(NSNumber *) aLongitude {
  NSDecimalNumber *lat = [LjsDn dnWithNumber:aLatitude];
  NSDecimalNumber *lon = [LjsDn dnWithNumber:aLongitude];
  return [self initWithLatitude:lat
                      longitude:lon
                          scale:LjsLocationManagerLocationScale];
}

- (id) initWithLatitudeFloat:(CGFloat) aLatitude
              longitudeFloat:(CGFloat) aLongitude {
  NSDecimalNumber *lat = [LjsDn dnWithFloat:aLatitude];
  NSDecimalNumber *lon = [LjsDn dnWithFloat:aLongitude];
  return [self initWithLatitude:lat
                      longitude:lon
                          scale:LjsLocationManagerLocationScale];
}


- (id) initWithLatitude:(NSDecimalNumber *)aLatitude 
              longitude:(NSDecimalNumber *)aLongitude {
  return [self initWithLatitude:aLatitude 
                      longitude:aLongitude
                          scale:LjsLocationManagerLocationScale];
}

- (id) initWithLatitude:(NSDecimalNumber *) aLatitude
              longitude:(NSDecimalNumber *) aLongitude
                  scale:(NSUInteger) aScale {
  self = [super init];
  if (self) {
    self.latitude = [aLatitude dnByRoundingWithScale:aScale];
    self.longitude = [aLongitude dnByRoundingWithScale:aScale];
    self.scale = aScale;
  }
  return self;
}

- (id) initWithCoreLocation:(CLLocation *) aLocation {
  self = [super init];
  if (self) {
    NSDecimalNumber *lat, *lon;
    if (aLocation == nil) {
      lat = [LjsDn nan];
      lon = [LjsDn nan];
    } else {
      lat = [LjsDn dnWithDouble:aLocation.coordinate.latitude];
      lon = [LjsDn dnWithDouble:aLocation.coordinate.longitude];
    }
    self.latitude = lat;
    self.longitude = lon;
  }
  return self;
}

- (CLLocation *) coreLocation {
  CLLocation *result = nil;
  if ([LjsLocationManager isValidLocation:self]) {
    result = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue]
                                        longitude:[self.longitude doubleValue]];
  }
  return result;
}


- (id) initWithLocation:(LjsLocation *) aLocation
                  scale:(NSUInteger) aScale {
  return [[LjsLocation alloc]
          initWithLatitude:aLocation.latitude
          longitude:aLocation.longitude
          scale:aScale];
}

+ (LjsLocation *) locationWithLocation:(LjsLocation *) aLocation
                                scale:(NSUInteger) aScale {
  return [[LjsLocation alloc] initWithLocation:aLocation
                                         scale:aScale];
}

- (BOOL) isSameLocation:(LjsLocation *) aLocation scale:(NSUInteger) aScale {
  LjsLocation *usScaled = [LjsLocation locationWithLocation:self
                                                      scale:aScale];
  LjsLocation *themScaled = [LjsLocation locationWithLocation:self
                                                        scale:aScale];
  return [LjsDn dn:usScaled.latitude e:themScaled.latitude] &&
  [LjsDn dn:usScaled.longitude e:themScaled.longitude];
}

- (BOOL) isSameLocation:(LjsLocation *) aLocation {
  return [LjsDn dn:self.latitude e:aLocation.latitude] &&
  [LjsDn dn:self.longitude e:aLocation.longitude];
}


- (NSString *) description {
  return [NSString stringWithFormat:@"#(%@, %@)", self.latitude, self.longitude];
}

+ (LjsLocation *) randomLocation {
  LjsInterval *latBounds = [LjsLocationManager latitudeBounds];
  NSDecimalNumber *lat =  [LjsVariates randomDecimalDoubleWithMin:latBounds.min
                                                              max:latBounds.max];
  LjsInterval *lonBounds = [LjsLocationManager longitudeBounds];
  NSDecimalNumber *lon = [LjsVariates randomDecimalDoubleWithMin:lonBounds.min
                                                             max:lonBounds.max];
  return [[LjsLocation alloc]
          initWithLatitude:lat longitude:lon];
}

+ (LjsLocation *) locationZurich {
  return [[LjsLocation alloc]
          initWithLatitudeFloat:LjsLatitudeZurich
          longitudeFloat:LjsLongitudeZurich];
}

@end



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


@end


@implementation LjsLocationManager

@synthesize coreLocationManager;
@synthesize coreLocation;
@synthesize coreHeading;
@synthesize debugDevices;
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

    
    LJS_DEBUG_LOCATION_SERVICES
    (
     self.debugDevices = [NSArray arrayWithObjects:LjsLocationManagerMercury,
                          LjsLocationManagerPluto, LjsLocationManagerNeptune, nil];
     self.debugLastHeading = [LjsVariates randomDoubleWithMin:0.0 max:360.0];
     )
    
       
  

  }
  return self;
}


+ (LjsInterval *) latitudeBounds {
  return [[LjsInterval alloc] initWithMin:[LjsDn dnWithString:@"-90.0"]
                                      max:[LjsDn dnWithString:@"90.0"]];
}

+ (LjsInterval *) longitudeBounds {
  return [[LjsInterval alloc] initWithMin:[LjsDn dnWithString:@"-180.0"]
                                      max:[LjsDn dnWithString:@"180.0"]];
}

+ (LjsInterval *) headingBounds {
  return [[LjsInterval alloc] initWithMin:[LjsDn dnWithString:@"0.0"]
                                      max:[LjsDn dnWithString:@"360.0"]];
  
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

  LJS_DEBUG_LOCATION_SERVICES
  (
   if (result == NO) {
     NSString *deviceName = [[UIDevice currentDevice] name];
     if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
       
       DDLogNotice(@"we are using a debug device: %@ and LJS_LOCATION_SERVICES_DEBUG is on so return true.", deviceName);
       result = YES;
     }
   }
   )
  
  LJS_DEBUG_LOCATION_SERVICES_SIMULATOR
  (
   if (result == NO) {
     DDLogDebug(@"result was NO, but LJS_LOCATION_SERVICES_SIMULATOR_DEBUG is on - will return YES");
     result = YES;
   } 
   )
  return result;
}


- (BOOL) headingIsAvailable {
  BOOL serviceAvailable = [CLLocationManager headingAvailable];
  
  LJS_DEBUG_LOCATION_SERVICES
  (
   if (serviceAvailable == NO) {
     NSString *deviceName = [[UIDevice currentDevice] name];
     if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
       DDLogNotice(@"we are using a debug device: %@ and LJS_LOCATION_SERVICES_DEBUG is on so return true.", deviceName);
       serviceAvailable = YES;
     }
   }
   )
  
  return serviceAvailable;
}

+ (BOOL) isValidHeading:(NSDecimalNumber *) aHeading {
  if ([aHeading isNan]) {
    return NO;
  } else {
    return [[LjsLocationManager headingBounds] intervalContains:aHeading];
  }
}


+ (BOOL) isValidLatitude:(NSDecimalNumber *) aLatitude {
  if ([aLatitude isNan]) {
    return NO;
  } else {
    return [[LjsLocationManager latitudeBounds] intervalContains:aLatitude];
  }
}


+ (BOOL) isValidLongitude:(NSDecimalNumber *) aLongitude {
 if ([aLongitude isNan]) {
    return NO;
  } else {
    return [[LjsLocationManager longitudeBounds] intervalContains:aLongitude];
  }
}



#pragma mark Latitude, Longitude, and Heading

- (NSDecimalNumber *) longitude {
  NSDecimalNumber *result;
  if (self.coreLocation == nil) {
    result = [LjsDn nan];
  } else {
    result = [[LjsDn dnWithDouble:self.coreLocation.coordinate.longitude] dnByRoundingAsLocation];
  }

  LJS_DEBUG_LOCATION_SERVICES 
  (
   if ([result isNan])  {
     NSString *deviceName = [[UIDevice currentDevice] name];
     if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
       DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
       result = [LjsDn dnWithFloat:LjsLongitudeZurich];
     } 
   }
   )
  
  LJS_DEBUG_LOCATION_SERVICES_SIMULATOR 
  (
   if ([result isNan]) {
     DDLogNotice(@"location is not available on the simulator - overriding");
     result = [LjsDn dnWithFloat:LjsLongitudeZurich];
   }
   )
  
  return result;
}

- (NSDecimalNumber *) latitude {
  NSDecimalNumber *result;
  if (self.coreLocation == nil) {
    result = [LjsDn nan];
  } else {
    result = [[LjsDn dnWithDouble:self.coreLocation.coordinate.latitude] dnByRoundingAsLocation];
  }
  
  LJS_DEBUG_LOCATION_SERVICES 
  (
   if ([result isNan])  {
     NSString *deviceName = [[UIDevice currentDevice] name];
     if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
       DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
       result = [LjsDn dnWithFloat:LjsLatitudeZurich];   
     } 
   }
   )
  
  
  LJS_DEBUG_LOCATION_SERVICES_SIMULATOR
  (
   if ([result isNan]) {
     DDLogNotice(@"location is not available on the simulator - overriding");
     result = [LjsDn dnWithFloat:LjsLatitudeZurich];
   }
   )

  return result;
}

- (NSDecimalNumber *) trueHeading {
  NSDecimalNumber *result;
  if (self.coreHeading == nil) {
    result = [LjsDn nan];
  } else {
    result = [[LjsDn dnWithDouble:self.coreHeading.trueHeading] dnByRoundingAsLocation];
  }

  LJS_DEBUG_LOCATION_SERVICES
  (
   if ([result isNan]) {
     NSString *deviceName = [[UIDevice currentDevice] name];
     if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
       DDLogNotice(@"heading is not available for device: %@ - overriding", deviceName);
       CGFloat random = [LjsVariates randomDoubleWithMin:5.0 max:10.0];
       CGFloat current = self.debugLastHeading;
       self.debugLastHeading = MIN(current + random, LjsMaxHeading);
       result = [[LjsDn dnWithFloat:self.debugLastHeading] dnByRoundingAsLocation];
     } 
   }
   )

  LJS_DEBUG_LOCATION_SERVICES_SIMULATOR
  (
   if ([result isNan]) {
     DDLogNotice(@"heading is not available for simulator - overriding");
     CGFloat random = [LjsVariates randomDoubleWithMin:5.0 max:10.0];
     NSUInteger signedness = [LjsVariates flip];
     if (signedness == 0) {
       random = random * -1.0;
     }
     CGFloat current = self.debugLastHeading;
     CGFloat new = MIN(current + random, LjsMaxHeading);
     self.debugLastHeading = MAX(new, LjsMinHeading);      
     result = [[LjsDn dnWithFloat:self.debugLastHeading] dnByRoundingAsLocation];
   }
   )
  
  return result;
}

- (LjsLocation *) location {
  return [[LjsLocation alloc]
          initWithLatitude:[self latitude]
          longitude:[self longitude]];
}

+ (BOOL) isValidLocation:(LjsLocation *) aLocation {
  return ([LjsLocationManager isValidLatitude:aLocation.latitude] &&
          [LjsLocationManager isValidLongitude:aLocation.longitude]);
}


- (NSDecimalNumber *) metersBetweenA:(LjsLocation *) a
                                   b:(LjsLocation *) b {
  return [self metersBetweenA:a
                            b:b
                        scale:LjsLocationManagerLocationScale];
}



- (NSDecimalNumber *) metersBetweenA:(LjsLocation *) a
                                   b:(LjsLocation *) b
                               scale:(NSUInteger) aScale {
  CLLocation *lA = [[CLLocation alloc] initWithLatitude:[a.latitude doubleValue]
                                              longitude:[a.longitude doubleValue]];
  CLLocation *lB = [[CLLocation alloc] initWithLatitude:[b.latitude doubleValue]
                                              longitude:[b.longitude doubleValue]];
  return [[LjsDn dnWithDouble:[lA distanceFromLocation:lB]] dnByRoundingWithScale:aScale];

}

- (NSDecimalNumber *) kilometersBetweenA:(LjsLocation *) a
                                       b:(LjsLocation *) b {
  return [self kilometersBetweenA:a b:b scale:LjsLocationManagerLocationScale];
}

- (NSDecimalNumber *) kilometersBetweenA:(LjsLocation *) a
                                       b:(LjsLocation *) b
                                   scale:(NSUInteger) aScale {
  NSDecimalNumber *meters = [self metersBetweenA:a b:b scale:aScale];
  return [meters decimalNumberByDividingBy:[LjsDn dnWithString:@"1000"]];
}


- (NSDecimalNumber *) feetBetweenA:(LjsLocation *) a
                                 b:(LjsLocation *) b {
  return [self feetBetweenA:a b:b scale:LjsLocationManagerLocationScale];
}

- (NSDecimalNumber *) feetBetweenA:(LjsLocation *) a
                                 b:(LjsLocation *) b
                             scale:(NSUInteger) aScale {
  NSDecimalNumber *meters = [self metersBetweenA:a b:b scale:aScale];
  return [meters decimalNumberByMultiplyingBy:[LjsDn dnWithString:@"3.2808399"]];
}

- (NSDecimalNumber *) milesBetweenA:(LjsLocation *) a
                                    b:(LjsLocation *) b {
  return [self milesBetweenA:a b:b scale:LjsLocationManagerLocationScale];
}

- (NSDecimalNumber *) milesBetweenA:(LjsLocation *) a
                                    b:(LjsLocation *) b
                                scale:(NSUInteger) aScale {
  NSDecimalNumber *meters = [self metersBetweenA:a b:b scale:aScale];
  return [meters decimalNumberByDividingBy:[LjsDn dnWithString:@"1609.344"]];
}




#pragma mark Reverse Geocoding 

- (void) detailsForLocation:(LjsLocation *) aLocation {
#if TARGET_OS_IPHONE
  Class clgeocoder = NSClassFromString(@"CLGeocoder");
  if (clgeocoder != nil) {
    CLLocation *loc =  [aLocation coreLocation];
    if (loc != nil) {
      CLGeocoder *coder = [[CLGeocoder alloc] init];
      [coder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
          NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
          [userInfo setObject:aLocation forKey:@"sourceLocation"];
          CLPlacemark *mark = [placemarks nth:0]; 
          LjsLocation *foundLoc =  [[LjsLocation alloc]
                                            initWithCoreLocation:[mark location]];
          [userInfo setObject:foundLoc forKey:@"foundLocation"];
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
    DDLogError(@"could not find class CLGeocoder - ");
    return;
  }
#else
  DDLogNotice(@"CLGeocoder not available on MacOS - will reverse geocode with Google API"); 
#endif
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
  DDLogError(@"failed to get location: %@ %@ %ld", [error domain],
             [error localizedDescription],
             (long)[error code]);
}

/**
 Asks the delegate whether the heading calibration alert should be displayed.
 @param manager the CLLocation manager
 @return Almost always we want to return NO.
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
