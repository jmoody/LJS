#import "_LjsGoogleBounds.h"

@class LjsGoogleReverseGeocode;

@interface LjsGoogleBounds : _LjsGoogleBounds {}

+ (LjsGoogleBounds *) initWithDictionary:(NSDictionary *) aDictionary
                            reverseGeocode:(LjsGoogleReverseGeocode *) aGeocode
                                   context:(NSManagedObjectContext *) aContext;
@end
