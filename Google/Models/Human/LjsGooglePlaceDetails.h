#import "_LjsGooglePlaceDetails.h"


@class LjsLocation;
@class LjsGooglePlacesNmoDetails;

@interface LjsGooglePlaceDetails : _LjsGooglePlaceDetails {}

+ (LjsGooglePlaceDetails *) initWithDetails:(LjsGooglePlacesNmoDetails *) aDetails
                                    context:(NSManagedObjectContext *) aContext;


- (NSString *) shortId;


@end






