#import <Foundation/Foundation.h>
#import "_LjsGoogleAddressComponentType.h"

@class LjsGoogleAddressComponent;

@interface LjsGoogleAddressComponentType : _LjsGoogleAddressComponentType


+ (LjsGoogleAddressComponentType *) findOrCreateWithName:(NSString *) aName
                                               component:(LjsGoogleAddressComponent *) aComponent
                                                 context:(NSManagedObjectContext *) aContext;

@end

//@interface LjsGoogleAddressComponentType (CoreDataGeneratedAccessors)
//
//- (void)addComponentsObject:(LjsGoogleAddressComponent *)value;
//- (void)removeComponentsObject:(LjsGoogleAddressComponent *)value;
//- (void)addComponents:(NSSet *)values;
//- (void)removeComponents:(NSSet *)values;
//
//@end
