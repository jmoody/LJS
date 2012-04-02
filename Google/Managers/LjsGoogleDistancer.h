#import <Foundation/Foundation.h>


@class LjsGooglePlace;
@class LjsLocation;
@class LjsLocationManager;
@class LjsGoogleReverseGeocode;

/**
 Documentation
 */
@interface LjsGoogleDistancer : NSObject 

/** @name Properties */

/** @name Initializing Objects */
- (id) initWithLocationManager:(LjsLocationManager *) aManager;

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */

- (NSDecimalNumber *) metersBetweenPlace:(LjsGooglePlace *) aPlace 
                             andLocation:(LjsLocation *) aLocation;


- (NSDecimalNumber *) metersBetweenPlaceA:(LjsGooglePlace *) a
                                   placeB:(LjsGooglePlace *) b;

- (NSDecimalNumber *) kilometersBetweenPlaceA:(LjsGooglePlace *) a
                                       placeB:(LjsGooglePlace *) b;

- (NSDecimalNumber *) feetBetweenPlaceA:(LjsGooglePlace *) a 
                                 placeB:(LjsGooglePlace *) b;
- (NSDecimalNumber *) milesBetweenPlaceA:(LjsGooglePlace *) a
                                  placeB:(LjsGooglePlace *) b;

- (NSComparisonResult) compareDistanceFromLocation:(LjsLocation *) aLocation
                                       toPlaceA:(LjsGooglePlace *) a
                                       toPlaceB:(LjsGooglePlace *) b;

- (NSComparisonResult) compareDistanceFromLocation:(LjsLocation *) aLocation
                                        toGeocodeA:(LjsGoogleReverseGeocode *) a
                                        toGeocodeB:(LjsGoogleReverseGeocode *) b;




@end
