#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LjsGooglePlace;

@interface LjsGooglePlaceType : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *places;

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
