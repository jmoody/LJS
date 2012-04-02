#import "_LjsGoogleAddressComponentPlace.h"

@class LjsGoogleNmoAddressComponent;
@class LjsGooglePlaceDetails;

@interface LjsGoogleAddressComponentPlace : _LjsGoogleAddressComponentPlace {}


+ (LjsGoogleAddressComponentPlace *) initWithComponent:(LjsGoogleNmoAddressComponent *) aComponent
                                            place:(LjsGooglePlaceDetails *) aPlace
                                          context:(NSManagedObjectContext *) aContext;

@end
