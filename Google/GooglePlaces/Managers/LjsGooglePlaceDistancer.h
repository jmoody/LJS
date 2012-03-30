#import <Foundation/Foundation.h>
#import "LjsLocationManager.h"

@class LjsGooglePlace;
/**
 Documentation
 */
@interface LjsGooglePlaceDistancer : NSObject 

/** @name Properties */

/** @name Initializing Objects */
- (id) initWithLocationManager:(LjsLocationManager *) aManager;

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */

- (CGFloat) metersBetweenPlace:(LjsGooglePlace *) aPlace 
                   andLocation:(LjsLocation) aLocation;
- (NSDecimalNumber *) dnMetersBetweenPlace:(LjsGooglePlace *) aPlace
                               andLocation:(LjsLocation) aLocation;

- (CGFloat) metersBetweenA:(LjsGooglePlace *) a
                         b:(LjsGooglePlace *) b;

- (CGFloat) kilometersBetweenA:(LjsGooglePlace *) a
                             b:(LjsGooglePlace *) b;

- (CGFloat) feetBetweenA:(LjsGooglePlace *) a 
                       b:(LjsGooglePlace *) b;
- (CGFloat) milesBetweenA:(LjsGooglePlace *) a
                        b:(LjsGooglePlace *) b;

- (NSComparisonResult) compareDistanceFrom:(LjsLocation) aLocation
                                       toA:(LjsGooglePlace *) a
                                       toB:(LjsGooglePlace *) b;


@end
