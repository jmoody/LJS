#import "_LjsGooglePlace.h"


@class LjsLocation;
@class LjsGooglePlacesNmoDetails;

@interface LjsGooglePlace : _LjsGooglePlace {}

+ (LjsGooglePlace *) initWithDetails:(LjsGooglePlacesNmoDetails *) aDetails
                                    context:(NSManagedObjectContext *) aContext;


- (NSString *) shortId;


@end






