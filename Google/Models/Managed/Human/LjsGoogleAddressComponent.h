#import <Foundation/Foundation.h>
#import "_LjsGoogleAddressComponent.h"

@class LjsGoogleAddressComponentType, LjsGooglePlace;
@class LjsGoogleNmoAddressComponent;

@interface LjsGoogleAddressComponent : _LjsGoogleAddressComponent


+ (LjsGoogleAddressComponent *) initWithComponent:(LjsGoogleNmoAddressComponent *) aComponent
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
