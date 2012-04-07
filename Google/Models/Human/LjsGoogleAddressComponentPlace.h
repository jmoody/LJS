#import "_LjsGoogleAddressComponentPlace.h"

@class LjsGoogleNmoAddressComponent;
@class LjsGooglePlace;

@interface LjsGoogleAddressComponentPlace : _LjsGoogleAddressComponentPlace {}


+ (LjsGoogleAddressComponentPlace *) initWithComponent:(LjsGoogleNmoAddressComponent *) aComponent
                                            place:(LjsGooglePlace *) aPlace
                                          context:(NSManagedObjectContext *) aContext;

@end
