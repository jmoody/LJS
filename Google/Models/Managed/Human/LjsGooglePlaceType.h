#import <Foundation/Foundation.h>
#import "_LjsGooglePlaceType.h"

@class LjsGooglePlace;

@interface LjsGooglePlaceType : _LjsGooglePlaceType


+ (LjsGooglePlaceType *) findOrCreateWithName:(NSString *) aName
                                        place:(LjsGooglePlace *) aPlace
                                      context:(NSManagedObjectContext *) aContext;
@end
//
//@interface LjsGooglePlaceType (CoreDataGeneratedAccessors)
//
//- (void)addPlacesObject:(LjsGooglePlace *)value;
//- (void)removePlacesObject:(LjsGooglePlace *)value;
//- (void)addPlaces:(NSSet *)values;
//- (void)removePlaces:(NSSet *)values;
//
//@end
