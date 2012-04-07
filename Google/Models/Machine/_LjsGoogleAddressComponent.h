// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAddressComponent.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleAddressComponentAttributes {
	__unsafe_unretained NSString *longName;
	__unsafe_unretained NSString *shortName;
} LjsGoogleAddressComponentAttributes;

extern const struct LjsGoogleAddressComponentRelationships {
	__unsafe_unretained NSString *types;
} LjsGoogleAddressComponentRelationships;

extern const struct LjsGoogleAddressComponentFetchedProperties {
} LjsGoogleAddressComponentFetchedProperties;

@class LjsGoogleAddressComponentType;




@interface LjsGoogleAddressComponentID : NSManagedObjectID {}
@end

@interface _LjsGoogleAddressComponent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleAddressComponentID*)objectID;




@property (nonatomic, strong) NSString *longName;


//- (BOOL)validateLongName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *shortName;


//- (BOOL)validateShortName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* types;

- (NSMutableSet*)typesSet;





@end

@interface _LjsGoogleAddressComponent (CoreDataGeneratedAccessors)

- (void)addTypes:(NSSet*)value_;
- (void)removeTypes:(NSSet*)value_;
- (void)addTypesObject:(LjsGoogleAddressComponentType*)value_;
- (void)removeTypesObject:(LjsGoogleAddressComponentType*)value_;

@end

@interface _LjsGoogleAddressComponent (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveLongName;
- (void)setPrimitiveLongName:(NSString *)value;




- (NSString *)primitiveShortName;
- (void)setPrimitiveShortName:(NSString *)value;





- (NSMutableSet*)primitiveTypes;
- (void)setPrimitiveTypes:(NSMutableSet*)value;


@end
