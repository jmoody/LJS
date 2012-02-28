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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 A singleton class wrapper around the Location Services.
 
 The accuracy is hard-wired to kCLLocationAccuracyNearestTenMeters and the 
 latitude, longitude, and heading are returned with with 5 decimal places.
 
 For testing and development, the class provides special handling if
 LJS_LOCATION_SERVICES_DEBUG Preprocessor Macro is defined or if the target is the
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
/** 
 a decimal number handler for converting coordinates to decimal numbers
 */
@property (nonatomic, strong) NSDecimalNumberHandler *handler;

/**
 indicates a bad latitude or longitude
 */
@property (nonatomic, strong) NSDecimalNumber *noLocation;

/**
 indidcates a bad heading
 */
@property (nonatomic, strong) NSDecimalNumber *noHeading;

#ifdef LJS_LOCATION_SERVICES_DEBUG 
/**
 available iff LJS_LOCATION_SERVICES_DEBUG Preprocessor Macro is defined
 */
@property (nonatomic, strong) NSArray *debugDevices;
#endif

/**
 used simulate the heading changing in environments where there is no heading
 available
 */
@property (nonatomic, strong) NSDecimalNumber *debugLastHeading;


#pragma mark Singleton
/** @name Obtaining the Instance */

/**
 implements the singleton pattern
 */
+ (id) sharedInstance;


/** @name Testing For Location and Heading Availability and Validity*/

/**
 @return true iff location is available
 @warning if LJS_LOCATION_SERVICES_DEBUG Preprocess Macro is defined, this 
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
 @warning if LJS_LOCATION_SERVICES_DEBUG Preprocess Macro is defined and no valid
 location can be found then this method will return the longitude for 
 Zurich, CH
 */
- (NSDecimalNumber *) longitude;

/**
 @return the current latitude as a rounded NSDecimalNumber
 @warning if LJS_LOCATION_SERVICES_DEBUG Preprocess Macro is defined and no valid
 location can be found then this method will return the latitude for 
 Zurich, CH
 */
- (NSDecimalNumber *) latitude;


/**
 @return the current latitude as a rounded NSDecimalNumber
 @warning if LJS_LOCATION_SERVICES_DEBUG Preprocess Macro is defined and no valid
 heading can be found then this method will return
 
 */
- (NSDecimalNumber *) trueHeading;

@end
