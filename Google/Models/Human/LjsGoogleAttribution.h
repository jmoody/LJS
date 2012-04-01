#import <Foundation/Foundation.h>
#import "_LjsGoogleAttribution.h"

@class LjsGooglePlacesNmoAttribution;
@class LjsGooglePlace;

@interface LjsGoogleAttribution : _LjsGoogleAttribution


+ (LjsGoogleAttribution *) findOrCreateWithAtribution:(LjsGooglePlacesNmoAttribution *) aAttribution
                                                place:(LjsGooglePlace *) aPlace
                                              context:(NSManagedObjectContext *) aContext;
@end


