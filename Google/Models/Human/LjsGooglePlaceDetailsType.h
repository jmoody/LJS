#import "_LjsGooglePlaceDetailsType.h"

@class LjsGooglePlaceDetails;

@interface LjsGooglePlaceDetailsType : _LjsGooglePlaceDetailsType {}

+ (LjsGooglePlaceDetailsType *) findOrCreateWithName:(NSString *) aName
                                        place:(LjsGooglePlaceDetails *) aPlace
                                      context:(NSManagedObjectContext *) aContext;

@end
