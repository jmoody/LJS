#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LjsGoogleAddressComponentType, LjsGooglePlace;
@class LjsGooglePlacesNmoAddressComponent;

@interface LjsGoogleAddressComponent : NSManagedObject

@property (nonatomic, strong) NSString * longName;
@property (nonatomic, strong) NSString * shortName;
@property (nonatomic, strong) LjsGooglePlace *place;
@property (nonatomic, strong) NSSet *types;

+ (LjsGoogleAddressComponent *) initWithComponent:(LjsGooglePlacesNmoAddressComponent *) aComponent
                                            place:(LjsGooglePlace *) aPlace
                                          context:(NSManagedObjectContext *) aContext;
@end

//@interface LjsGoogleAddressComponent (CoreDataGeneratedAccessors)
//
//- (void)addTypesObject:(LjsGoogleAddressComponentType *)value;
//- (void)removeTypesObject:(LjsGoogleAddressComponentType *)value;
//- (void)addTypes:(NSSet *)values;
//- (void)removeTypes:(NSSet *)values;
//
//@end
