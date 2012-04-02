#import "_LjsGooglePlaceType.h"

@class LjsGooglePlace;

@interface LjsGooglePlaceType : _LjsGooglePlaceType {}

+ (LjsGooglePlaceType *) findOrCreateWithName:(NSString *) aName
                                        place:(LjsGooglePlace *) aPlace
                                      context:(NSManagedObjectContext *) aContext;

@end
