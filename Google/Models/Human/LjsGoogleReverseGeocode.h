#import "_LjsGoogleReverseGeocode.h"

@class LjsGoogleNmoReverseGeocode;

@interface LjsGoogleReverseGeocode : _LjsGoogleReverseGeocode {}

+ (LjsGoogleReverseGeocode *) initWithReverseGeocode:(LjsGoogleNmoReverseGeocode *) aGeocode
                                       context:(NSManagedObjectContext *) aContext;

@end
