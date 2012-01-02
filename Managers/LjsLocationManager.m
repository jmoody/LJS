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
#import "LjsDecimalAide.h"
#import "LjsValidator.h"
#import "LjsVariates.h"
#import "Lumberjack.h"

static const int ddLogLevel = LOG_LEVEL_WARN;

//#ifdef LOG_CONFIGURATION_DEBUG
//static const int ddLogLevel = LOG_LEVEL_DEBUG;
//#else
//
//#endif

static CGFloat const LjsLocationManagerLocationHeadingNotFound = -999.0;

static CGFloat const LjsLocationManagerHeadingMin = 0.0;
static CGFloat const LjsLocationManagerHeadingMax = 360.0;
static CGFloat const LjsLocationManagerLongitudeMin = -180.0;
static CGFloat const LjsLocationManagerLongitudeMax = 180.0;
static CGFloat const LjsLocationManagerLatitudeMin = -90.0;
static CGFloat const LjsLocationManagerLatitudeMax = 90.0;


#ifdef LJS_LOCATION_SERVICES_DEBUG
static NSString *LjsLocationManagerMercury = @"mercury";
static NSString *LjsLocationManagerPluto = @"pluto";
#endif

static NSString *LjsLocationManagerZurichLongitude = @"42.22";
static NSString *LjsLocationManagerZurichLatitude = @"8.32";


static LjsLocationManager *singleton = nil;

@implementation LjsLocationManager

@synthesize coreLocationManager;
@synthesize handler;
@synthesize noLocation;
@synthesize coreLocation;
@synthesize noHeading;
@synthesize coreHeading;

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
    
    if ([CLLocationManager headingAvailable]) {
      DDLogDebug(@"heading service available, starting orientation tracking.");
      [self.coreLocationManager startUpdatingHeading];
    } else {
      DDLogDebug(@"heading service unavailable");
    }

    self.handler = [LjsDecimalAide locationHandlerWithRoundMode:NSRoundPlain
                                                          scale:5];
    
    self.noLocation = [LjsDecimalAide dnWithDouble:LjsLocationManagerLocationHeadingNotFound];
    
    self.noHeading = self.noLocation;
    
#ifdef LJS_LOCATION_SERVICES_DEBUG
    self.debugDevices = [NSArray arrayWithObjects:LjsLocationManagerMercury,
                         LjsLocationManagerPluto, nil];
#endif
    double random = [LjsVariates randomDoubleWithMin:0.0 max:360.0];
    self.debugLastHeading = [LjsDecimalAide dnWithDouble:random];
  }
  return self;
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


+ (BOOL) isValidHeading:(NSDecimalNumber *) aHeading {
  if (aHeading == nil) {
    return NO;
  } else {
    NSDecimalNumber *min = [LjsDecimalAide dnWithDouble:LjsLocationManagerHeadingMin];
    NSDecimalNumber *max = [LjsDecimalAide dnWithDouble:LjsLocationManagerHeadingMax];
    return [LjsDecimalAide dn:aHeading isOnMin:min max:max];
  }
}


+ (BOOL) isValidLatitude:(NSDecimalNumber *) aLatitude {
  if (aLatitude == nil) {
    return NO;
  } else {
    NSDecimalNumber *min = [LjsDecimalAide dnWithDouble:LjsLocationManagerLatitudeMin];
    NSDecimalNumber *max = [LjsDecimalAide dnWithDouble:LjsLocationManagerLatitudeMax];
    return [LjsDecimalAide dn:aLatitude isOnMin:min max:max];
  }
}


+ (BOOL) isValidLongitude:(NSDecimalNumber *) aLongitude {
  if (aLongitude == nil) {
    return NO;
  } else {
    NSDecimalNumber *min = [LjsDecimalAide dnWithDouble:LjsLocationManagerLongitudeMin];
    NSDecimalNumber *max = [LjsDecimalAide dnWithDouble:LjsLocationManagerLongitudeMax];
    return [LjsDecimalAide dn:aLongitude isOnMin:min max:max];
  }
}


#pragma mark Latitude, Longitude, and Heading

- (NSDecimalNumber *) longitude {
  NSDecimalNumber *result;
  if (self.coreLocation == nil) {
    result = self.noLocation;
  } else {
    result = [LjsDecimalAide dnWithDouble:self.coreLocation.coordinate.longitude];
    result = [result decimalNumberByRoundingAccordingToBehavior:self.handler];
  }
  
  
#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if ([LjsDecimalAide dn:self.noLocation e:result]) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
      result = [LjsDecimalAide dnWithString:LjsLocationManagerZurichLongitude];
    } 
  }
#endif
  
#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if ([LjsDecimalAide dn:self.noLocation e:result]) {
    DDLogNotice(@"location is not available on the simulator - overriding");
    result = [LjsDecimalAide dnWithString:LjsLocationManagerZurichLongitude];
  }
#endif

  return result;
}

- (NSDecimalNumber *) latitude {
  NSDecimalNumber *result;
  if (self.coreLocation == nil) {
    result = self.noLocation;
  } else {
    result = [LjsDecimalAide dnWithDouble:self.coreLocation.coordinate.latitude];
    result = [result decimalNumberByRoundingAccordingToBehavior:self.handler];
  }
  
#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if ([LjsDecimalAide dn:self.noLocation e:result]) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
      result = [LjsDecimalAide dnWithString:LjsLocationManagerZurichLatitude];
    } 
  }
#endif
  
  
#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if ([LjsDecimalAide dn:self.noLocation e:result]) {
    DDLogNotice(@"location is not available on the simulator - overriding");
    result = [LjsDecimalAide dnWithString:LjsLocationManagerZurichLatitude];
  }
#endif

  return result;
}

- (NSDecimalNumber *) trueHeading {
  NSDecimalNumber *result;
  if (self.coreHeading == nil) {
    result = self.noHeading;
  } else {
    NSDecimalNumber *trueHeading = [LjsDecimalAide dnWithDouble:self.coreHeading.trueHeading];
    result = [trueHeading decimalNumberByRoundingAccordingToBehavior:self.handler];
  }

#ifdef LJS_LOCATION_SERVICES_DEBUG 
  if ([LjsDecimalAide dn:self.noHeading e:result]) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"heading is not available for device: %@ - overriding", deviceName);
      double random = [LjsVariates randomDoubleWithMin:5.0 max:10.0];
      double current = [self.debugLastHeading doubleValue];
      double new = current + random;
      
      if (new > LjsLocationManagerHeadingMax) {
        new = LjsLocationManagerHeadingMax;
      }
      
      self.debugLastHeading = [LjsDecimalAide dnWithDouble:new];
      result = self.debugLastHeading;
    } 
  }
#endif

#ifdef LJS_LOCATION_SERVICES_SIMULATOR_DEBUG
  if ([LjsDecimalAide dn:self.noHeading e:result]) {
    DDLogNotice(@"heading is not available for simulator - overriding");
    double random = [LjsVariates randomDoubleWithMin:5.0 max:10.0];
    NSUInteger signedness = [LjsVariates randomIntegerWithMin:0 max:1];
    if (signedness == 0) {
      random = random * -1.0;
    }
    double current = [self.debugLastHeading doubleValue];
    double new = current + random;
    if (new > LjsLocationManagerHeadingMax) {
      new = LjsLocationManagerHeadingMin;
    } else if (new < LjsLocationManagerHeadingMin) {
      new = LjsLocationManagerHeadingMax;
    }
      
    self.debugLastHeading = [LjsDecimalAide dnWithDouble:new];
    result = self.debugLastHeading;
  }
#endif
  return result;
}



#pragma mark CLLocationManagerDelegate 

/** @name CLLocationManagerDelegate implementation */

/**
 Sets the `self.coreLocation` ivar to the new location.
 
 @param manager The location manager object that generated the update event.
 @param newLocation The new location data.
 @param oldLocation The location data from the previous update. If this is the first update event delivered by this location manager, this parameter is nil.
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
 @param error The error object containing the reason the location or heading could not be retrieved.
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
