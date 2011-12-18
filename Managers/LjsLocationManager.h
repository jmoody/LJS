#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 A singleton class wrapper around the Location Services.
 
 The accuracy is hard-wired to kCLLocationAccuracyNearestTenMeters and the 
 latitude, longitude, and heading are returned with with 5 decimal places.
 
 For testing and development, the class provides special handling if
 LOCATION_SERVICES_DEBUG:
 
 1. class will return YES for `locationIsAvailable`
 2. class will return Zurich, CH longitude for `longitude` if long cannont be found
 3. class will return Zurich, CH latitude for `latitude` if lat cannot be found
 
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

/**
 available iff LOCATION_SERVICES_DEBUG Preprocessor Macro is defined - used to
 simulate the heading changing
 */
@property (nonatomic, retain) NSDecimalNumber *debugLastHeading;

#endif

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
 @return true iff aLatitude is unknown
 @param aLatitude the latitude to check
 @warning It is better to use `locationIsAvailable`
 */
- (BOOL) isUnknownLatitude:(NSDecimalNumber *) aLatitude;

/**
 @return true iff aLatitude is unknown
 @param aLongitude the latitude to check
 @warning It is better to use `locationIsAvailable`
 */
- (BOOL) isUnknownLongitude:(NSDecimalNumber *) aLongitude;

/**
 @return true iff aHeading is unknown
 @param aHeading the heading to check
 @warning It is better to use `headingAvailable`
 */
- (BOOL) isUnknownHeading:(NSDecimalNumber *) aHeading;


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
