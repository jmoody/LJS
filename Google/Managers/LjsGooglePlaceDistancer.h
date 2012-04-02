#import <Foundation/Foundation.h>


@class LjsGooglePlaceDetails;
@class LjsLocation;
@class LjsLocationManager;

/**
 Documentation
 */
@interface LjsGooglePlaceDistancer : NSObject 

/** @name Properties */

/** @name Initializing Objects */
- (id) initWithLocationManager:(LjsLocationManager *) aManager;

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */

- (NSDecimalNumber *) metersBetweenPlace:(LjsGooglePlaceDetails *) aPlace 
                             andLocation:(LjsLocation *) aLocation;


- (NSDecimalNumber *) metersBetweenA:(LjsGooglePlaceDetails *) a
                                   b:(LjsGooglePlaceDetails *) b;

- (NSDecimalNumber *) kilometersBetweenA:(LjsGooglePlaceDetails *) a
                                       b:(LjsGooglePlaceDetails *) b;

- (NSDecimalNumber *) feetBetweenA:(LjsGooglePlaceDetails *) a 
                                 b:(LjsGooglePlaceDetails *) b;
- (NSDecimalNumber *) milesBetweenA:(LjsGooglePlaceDetails *) a
                                  b:(LjsGooglePlaceDetails *) b;

- (NSComparisonResult) compareDistanceFrom:(LjsLocation *) aLocation
                                       toA:(LjsGooglePlaceDetails *) a
                                       toB:(LjsGooglePlaceDetails *) b;


@end
