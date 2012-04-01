#import <Foundation/Foundation.h>
#import "_LjsGoogleAttribution.h"

@class LjsGooglePlacesNmoAttribution;
@class LjsGooglePlace;

@interface LjsGoogleAttribution : _LjsGoogleAttribution


+ (LjsGoogleAttribution *) findOrCreateWithAtribution:(LjsGooglePlacesNmoAttribution *) aAttribution
                                                place:(LjsGooglePlace *) aPlace
                                              context:(NSManagedObjectContext *) aContext;
@end



//@interface LjsGoogleAttribution (CoreDataGeneratedAccessors)
//
//- (void)addPlacesObject:(NSManagedObject *)value;
//- (void)removePlacesObject:(NSManagedObject *)value;
//- (void)addPlaces:(NSSet *)values;
//- (void)removePlaces:(NSSet *)values;
//@end
