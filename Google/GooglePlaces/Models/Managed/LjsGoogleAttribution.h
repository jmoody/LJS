#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LjsGooglePlacesNmoAttribution;
@class LjsGooglePlace;

@interface LjsGoogleAttribution : NSManagedObject
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSSet *places;

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
