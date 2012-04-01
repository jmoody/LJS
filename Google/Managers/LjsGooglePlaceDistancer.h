#import <Foundation/Foundation.h>


@class LjsGooglePlace;
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

- (NSDecimalNumber *) metersBetweenPlace:(LjsGooglePlace *) aPlace 
                             andLocation:(LjsLocation *) aLocation;


- (NSDecimalNumber *) metersBetweenA:(LjsGooglePlace *) a
                                   b:(LjsGooglePlace *) b;

- (NSDecimalNumber *) kilometersBetweenA:(LjsGooglePlace *) a
                                       b:(LjsGooglePlace *) b;

- (NSDecimalNumber *) feetBetweenA:(LjsGooglePlace *) a 
                                 b:(LjsGooglePlace *) b;
- (NSDecimalNumber *) milesBetweenA:(LjsGooglePlace *) a
                                  b:(LjsGooglePlace *) b;

- (NSComparisonResult) compareDistanceFrom:(LjsLocation *) aLocation
                                       toA:(LjsGooglePlace *) a
                                       toB:(LjsGooglePlace *) b;


@end
