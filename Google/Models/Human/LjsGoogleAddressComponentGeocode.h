#import "_LjsGoogleAddressComponentGeocode.h"

@class LjsGoogleNmoAddressComponent;
@class LjsGoogleReverseGeocode;

@interface LjsGoogleAddressComponentGeocode : _LjsGoogleAddressComponentGeocode {}


+ (LjsGoogleAddressComponentGeocode *) initWithComponent:(LjsGoogleNmoAddressComponent *) aComponent
                                                   gecode:(LjsGoogleReverseGeocode *) aGeocode
                                                 context:(NSManagedObjectContext *) aContext;

@end
