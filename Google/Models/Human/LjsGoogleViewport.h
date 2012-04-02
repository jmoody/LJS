#import "_LjsGoogleViewport.h"

@class LjsGoogleReverseGeocode;

@interface LjsGoogleViewport : _LjsGoogleViewport {}

+ (LjsGoogleViewport *) initWithDictionary:(NSDictionary *) aDictionary
                            reverseGeocode:(LjsGoogleReverseGeocode *) aGeocode
                                   context:(NSManagedObjectContext *) aContext;


@end
