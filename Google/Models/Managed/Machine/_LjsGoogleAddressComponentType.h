// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAddressComponentType.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleAddressComponentTypeAttributes {
	__unsafe_unretained NSString *name;
} LjsGoogleAddressComponentTypeAttributes;

extern const struct LjsGoogleAddressComponentTypeRelationships {
	__unsafe_unretained NSString *components;
} LjsGoogleAddressComponentTypeRelationships;

extern const struct LjsGoogleAddressComponentTypeFetchedProperties {
} LjsGoogleAddressComponentTypeFetchedProperties;

@class LjsGoogleAddressComponent;



@interface LjsGoogleAddressComponentTypeID : NSManagedObjectID {}
@end

@interface _LjsGoogleAddressComponentType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleAddressComponentTypeID*)objectID;




@property (nonatomic, strong) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* components;

- (NSMutableSet*)componentsSet;





@end

@interface _LjsGoogleAddressComponentType (CoreDataGeneratedAccessors)

- (void)addComponents:(NSSet*)value_;
- (void)removeComponents:(NSSet*)value_;
- (void)addComponentsObject:(LjsGoogleAddressComponent*)value_;
- (void)removeComponentsObject:(LjsGoogleAddressComponent*)value_;

@end

@interface _LjsGoogleAddressComponentType (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;





- (NSMutableSet*)primitiveComponents;
- (void)setPrimitiveComponents:(NSMutableSet*)value;


@end
