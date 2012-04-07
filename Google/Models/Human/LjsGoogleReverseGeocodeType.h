#import "_LjsGoogleReverseGeocodeType.h"

@class LjsGoogleReverseGeocode;
@interface LjsGoogleReverseGeocodeType : _LjsGoogleReverseGeocodeType {}

+ (LjsGoogleReverseGeocodeType *) findOrCreateWithName:(NSString *) aName
                                               geocode:(LjsGoogleReverseGeocode *) aGeocode
                                               context:(NSManagedObjectContext *) aContext;

@end
