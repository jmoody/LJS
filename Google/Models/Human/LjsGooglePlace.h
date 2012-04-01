#import <Foundation/Foundation.h>
#import "_LjsGooglePlace.h"


@class LjsGoogleAddressComponent, LjsGoogleAttribution, LjsGooglePlaceType;
@class LjsGooglePlacesDetails;


@interface LjsGooglePlace : _LjsGooglePlace

+ (LjsGooglePlace *) initWithDetails:(LjsGooglePlacesDetails *) aDetails
                             context:(NSManagedObjectContext *) aContext;


- (NSString *) shortId;

@end

