#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 A singleton class wrapper around the Location Services.
 
 The accuracy is hard-wired to kCLLocationAccuracyNearestTenMeters and the 
 latitude, longitude, and heading are returned with with 5 decimal places.
 
 For testing and development, the class provides special handling if
 LOCATION_SERVICES_DEBUG Preprocessor Macro is defined or if the target is the
 iphone simulator:
 
 1. class will return YES for `locationIsAvailable`
 2. class will return Zurich, CH longitude for `longitude` if long cannont be found
 3. class will return Zurich, CH latitude for `latitude` if lat cannot be found
 4. class will return a random heading on (0.0, 360.0) for the initial call
    and for every subsequent call, the heading will vary between 5 and 10 degrees
    to simulate the a change in heading.
 5. class will return YES for `headingIsAvailable`
 
 
 @warning Have not tested/used this class on MacOS.
 
 @bug This class follows the singleton pattern, but does not rigorously 
 implement the pattern.  Do not subclass and do not call the init methods
 directly.
 */
@interface LjsLocationManager : NSObject <CLLocationManagerDelegate> 

/** @name Properties */
/** 
 the core location manager
 @warning do not access directly use locationAvailable, longitude, and latitude
 methods */
@property (nonatomic, retain) CLLocationManager *coreLocationManager;
/** 
 the current location
 @warning do not access directly use locationAvailable, longitude, and latitude
 methods */
@property (nonatomic, retain) CLLocation *coreLocation;

/** 
 the current heading
 @warning do not access directly use headingAvailable and heading methods
 methods */
@property (nonatomic, retain) CLHeading *coreHeading;
/** 
 a decimal number handler for converting coordinates to decimal numbers
 */
@property (nonatomic, retain) NSDecimalNumberHandler *handler;

/**
 indicates a bad latitude or longitude
 */
@property (nonatomic, retain) NSDecimalNumber *noLocation;

/**
 indidcates a bad heading
 */
@property (nonatomic, retain) NSDecimalNumber *noHeading;

#ifdef LOCATION_SERVICES_DEBUG 
/**
 available iff LOCATION_SERVICES_DEBUG Preprocessor Macro is defined
 */
@property (nonatomic, retain) NSArray *debugDevices;
#endif

/**
 used simulate the heading changing in environments where there is no heading
 available
 */
@property (nonatomic, retain) NSDecimalNumber *debugLastHeading;


#pragma mark Singleton
/** @name Obtaining the Instance */

/**
 implements the singleton pattern
 */
+ (id) sharedInstance;


/** @name Testing For Location and Heading Availability and Validity*/

/**
 @return true iff location is available
 @warning if LOCATION_SERVICES_DEBUG Preprocess Macro is defined, this 
 method will always return YES
 */
- (BOOL) locationIsAvailable;

/**
 @return true iff aHeading is on (0.0, 360.0)
 @param aHeading the heading to check
 */
+ (BOOL) isValidHeading:(NSDecimalNumber *) aHeading;

/**
 @return true if aLatitude is on (-90.0, 90.0)
 @param aLatitude the latitude to check
 */
+ (BOOL) isValidLatitude:(NSDecimalNumber *) aLatitude;

/**
 @return true if aLongitude is on (-180.0, 180.0)
 @param aLongitude the longitude to check  
 */
+ (BOOL) isValidLongitude:(NSDecimalNumber *) aLongitude;

/**
 @return true iff heading is available
 */
- (BOOL) headingIsAvailable;

/** @name Finding Longitude, Latitude, and Heading */

/**
 @return the current longitude as a rounded NSDecimalNumber
 @warning if LOCATION_SERVICES_DEBUG Preprocess Macro is defined and no valid
 location can be found then this method will return the longitude for 
 Zurich, CH
 */
- (NSDecimalNumber *) longitude;

/**
 @return the current latitude as a rounded NSDecimalNumber
 @warning if LOCATION_SERVICES_DEBUG Preprocess Macro is defined and no valid
 location can be found then this method will return the latitude for 
 Zurich, CH
 */
- (NSDecimalNumber *) latitude;


/**
 @return the current latitude as a rounded NSDecimalNumber
 @warning if LOCATION_SERVICES_DEBUG Preprocess Macro is defined and no valid
 heading can be found then this method will return
 
 */
- (NSDecimalNumber *) trueHeading;

@end
