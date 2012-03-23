#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LjsGoogleAddressComponent;

@interface LjsGoogleAddressComponentType : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *components;

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
