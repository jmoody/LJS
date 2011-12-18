#import "LjsLocationManager.h"
#import "LjsDecimalAide.h"
#import "LjsValidator.h"

#ifdef LOCATION_SERVICES_DEBUG
#import "LjsVariates.h"
#endif


static const int ddLogLevel = LOG_LEVEL_WARN;

//#ifdef LOG_CONFIGURATION_DEBUG
//static const int ddLogLevel = LOG_LEVEL_DEBUG;
//#else
//
//#endif

static CGFloat const LocationDelegateLocationNotFound = -999.0;

#ifdef LOCATION_SERVICES_DEBUG
static NSString *LjsLocationManagerMercury = @"mercury";
static NSString *LjsLocationManagerPluto = @"pluto";

static NSString *LjsLocationManagerZurichLongitude = @"42.22";
static NSString *LjsLocationManagerZurichLatitude = @"8.32";
#endif

static LjsLocationManager *singleton = nil;

@implementation LjsLocationManager

@synthesize coreLocationManager;
@synthesize handler;
@synthesize noLocation;
@synthesize coreLocation;
@synthesize noHeading;
@synthesize coreHeading;

#ifdef LOCATION_SERVICES_DEBUG
@synthesize debugDevices;
@synthesize debugLastHeading;
#endif


#pragma mark Memory Management

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.coreLocationManager = nil;
  self.coreLocation = nil;
  self.handler = nil;
  self.noLocation = nil;
  self.noHeading = nil;
  self.coreHeading = nil;
#ifdef LOCATION_SERVICES_DEBUG
  self.debugDevices = nil;
  self.debugLastHeading = nil;
#endif
  [super dealloc];
}

+ (id) sharedInstance {
  @synchronized(self) {
    if (singleton == nil)
      singleton = [[super allocWithZone:NULL] init];
  }
  return singleton;
}

+ (id)allocWithZone:(NSZone *)zone {
  return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

- (unsigned)retainCount {
  return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void) release { 
  /* do nothing */
}

- (id)autorelease {
  return self;
}

- (id) init {
  self = [super init];
  if (self != nil) {
    self.coreLocationManager = [[[CLLocationManager alloc] init] autorelease];
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
    
    self.noLocation = [LjsDecimalAide dnWithDouble:LocationDelegateLocationNotFound];
    
    self.noHeading = self.noLocation;
    
#ifdef LOCATION_SERVICES_DEBUG
    self.debugDevices = [NSArray arrayWithObjects:LjsLocationManagerMercury,
                         LjsLocationManagerPluto, nil];
    double random = [LjsVariates randomDoubleWithMin:0.0 max:360.0];
    self.debugLastHeading = [LjsDecimalAide dnWithDouble:random];
#endif
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

#ifdef LOCATION_SERVICES_DEBUG
  if (result == NO) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      
      DDLogNotice(@"we are using a debug device: %@ and LOCATION_SERVICES_DEBUG is on so return true.", deviceName);
      result = YES;
    }
  }
#endif

  return result;
}


- (BOOL) headingIsAvailable {
  BOOL serviceAvailable = [CLLocationManager headingAvailable];
  
#ifdef LOCATION_SERVICES_DEBUG
  if (serviceAvailable == NO) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"we are using a debug device: %@ and LOCATION_SERVICES_DEBUG is on so return true.", deviceName);
      serviceAvailable = YES;
    }
  }
#endif
  return serviceAvailable;
}

- (BOOL) isUnknownLatitude:(NSDecimalNumber *) aLatitude {
  return [LjsDecimalAide dn:self.noLocation e:aLatitude];
}

- (BOOL) isUnknownLongitude:(NSDecimalNumber *) aLongitude {
  return [LjsDecimalAide dn:self.noLocation e:aLongitude];
}

- (BOOL) isUnknownHeading:(NSDecimalNumber *) aHeading {
  return [LjsDecimalAide dn:self.noHeading e:aHeading];
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
  
  
#ifdef LOCATION_SERVICES_DEBUG 
  if ([self isUnknownLongitude:result]) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
      result = [LjsDecimalAide dnWithString:LjsLocationManagerZurichLongitude];
    } 
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
  
#ifdef LOCATION_SERVICES_DEBUG 
  if ([self isUnknownLatitude:result]) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"location is not available for device: %@ - overriding", deviceName);
      result = [LjsDecimalAide dnWithString:LjsLocationManagerZurichLatitude];
    } 
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
#ifdef LOCATION_SERVICES_DEBUG 
  if ([self isUnknownHeading:result]) {
    NSString *deviceName = [[UIDevice currentDevice] name];
    if ([LjsValidator array:self.debugDevices containsString:deviceName]) {
      DDLogNotice(@"heading is not available for device: %@ - overriding", deviceName);
      double random = [LjsVariates randomDoubleWithMin:5.0 max:10.0];
      double current = [self.debugLastHeading doubleValue];
      double new = current + random;
      self.debugLastHeading = [LjsDecimalAide dnWithDouble:new];
      result = self.debugLastHeading;
    } 
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
