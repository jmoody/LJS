// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlace.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGooglePlaceAttributes {
	__unsafe_unretained NSString *dateAdded;
	__unsafe_unretained NSString *dateModified;
	__unsafe_unretained NSString *formattedAddress;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *orderValue;
} LjsGooglePlaceAttributes;

extern const struct LjsGooglePlaceRelationships {
	__unsafe_unretained NSString *addressComponents;
} LjsGooglePlaceRelationships;

extern const struct LjsGooglePlaceFetchedProperties {
} LjsGooglePlaceFetchedProperties;

@class LjsGoogleAddressComponent;




@class NSObject;


@interface LjsGooglePlaceID : NSManagedObjectID {}
@end

@interface _LjsGooglePlace : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGooglePlaceID*)objectID;




@property (nonatomic, strong) NSDate *dateAdded;


//- (BOOL)validateDateAdded:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate *dateModified;


//- (BOOL)validateDateModified:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *formattedAddress;


//- (BOOL)validateFormattedAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id location;


//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *orderValue;


//- (BOOL)validateOrderValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* addressComponents;

- (NSMutableSet*)addressComponentsSet;





@end

@interface _LjsGooglePlace (CoreDataGeneratedAccessors)

- (void)addAddressComponents:(NSSet*)value_;
- (void)removeAddressComponents:(NSSet*)value_;
- (void)addAddressComponentsObject:(LjsGoogleAddressComponent*)value_;
- (void)removeAddressComponentsObject:(LjsGoogleAddressComponent*)value_;

@end

@interface _LjsGooglePlace (CoreDataGeneratedPrimitiveAccessors)


- (NSDate *)primitiveDateAdded;
- (void)setPrimitiveDateAdded:(NSDate *)value;




- (NSDate *)primitiveDateModified;
- (void)setPrimitiveDateModified:(NSDate *)value;




- (NSString *)primitiveFormattedAddress;
- (void)setPrimitiveFormattedAddress:(NSString *)value;




- (id)primitiveLocation;
- (void)setPrimitiveLocation:(id)value;




- (NSDecimalNumber *)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(NSDecimalNumber *)value;





- (NSMutableSet*)primitiveAddressComponents;
- (void)setPrimitiveAddressComponents:(NSMutableSet*)value;


@end
