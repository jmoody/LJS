#import <Foundation/Foundation.h>
#import "_LjsGooglePlace.h"
#import "LjsLocationManager.h"

@class LjsGoogleAddressComponent, LjsGoogleAttribution, LjsGooglePlaceType;
@class LjsGooglePlacesDetails;


@interface LjsGooglePlace : _LjsGooglePlace

+ (LjsGooglePlace *) initWithDetails:(LjsGooglePlacesDetails *) aDetails
                             context:(NSManagedObjectContext *) aContext;



- (CGFloat) rating;
- (void) setRating:(CGFloat) aValue;
- (NSString *) shortId;

@end

