#import "_LjsGoogleReverseGeocode.h"
#import "LjsLocationManager.h"

@interface LjsLocation (LjsLocation_LjsReverseGeocodeAdditions)

- (NSString *) key;
@end

@class LjsGoogleNmoReverseGeocode;

@interface LjsGoogleReverseGeocode : _LjsGoogleReverseGeocode {}

+ (LjsGoogleReverseGeocode *) initWithReverseGeocode:(LjsGoogleNmoReverseGeocode *) aGeocode
                                       context:(NSManagedObjectContext *) aContext;


@end
