// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleReverseGeocode.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleReverseGeocodeAttributes {
	__unsafe_unretained NSString *dateAdded;
	__unsafe_unretained NSString *dateModified;
	__unsafe_unretained NSString *formattedAddress;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *latitude100m;
	__unsafe_unretained NSString *latitude1km;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *location100m;
	__unsafe_unretained NSString *locationType;
	__unsafe_unretained NSString *longitude100m;
	__unsafe_unretained NSString *longitude1km;
	__unsafe_unretained NSString *orderValue;
} LjsGoogleReverseGeocodeAttributes;

extern const struct LjsGoogleReverseGeocodeRelationships {
	__unsafe_unretained NSString *addressComponents;
	__unsafe_unretained NSString *bounds;
	__unsafe_unretained NSString *types;
	__unsafe_unretained NSString *viewport;
} LjsGoogleReverseGeocodeRelationships;

extern const struct LjsGoogleReverseGeocodeFetchedProperties {
} LjsGoogleReverseGeocodeFetchedProperties;

@class LjsGoogleAddressComponentGeocode;
@class LjsGoogleBounds;
@class LjsGoogleReverseGeocodeType;
@class LjsGoogleViewport;







@class NSObject;
@class NSObject;





@interface LjsGoogleReverseGeocodeID : NSManagedObjectID {}
@end

@interface _LjsGoogleReverseGeocode : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleReverseGeocodeID*)objectID;




@property (nonatomic, strong) NSDate *dateAdded;


//- (BOOL)validateDateAdded:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate *dateModified;


//- (BOOL)validateDateModified:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *formattedAddress;


//- (BOOL)validateFormattedAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *key;


//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *latitude100m;


//- (BOOL)validateLatitude100m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *latitude1km;


//- (BOOL)validateLatitude1km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id location;


//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id location100m;


//- (BOOL)validateLocation100m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *locationType;


//- (BOOL)validateLocationType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude100m;


//- (BOOL)validateLongitude100m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude1km;


//- (BOOL)validateLongitude1km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *orderValue;


//- (BOOL)validateOrderValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* addressComponents;

- (NSMutableSet*)addressComponentsSet;




@property (nonatomic, strong) LjsGoogleBounds* bounds;

//- (BOOL)validateBounds:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet* types;

- (NSMutableSet*)typesSet;




@property (nonatomic, strong) LjsGoogleViewport* viewport;

//- (BOOL)validateViewport:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleReverseGeocode (CoreDataGeneratedAccessors)

- (void)addAddressComponents:(NSSet*)value_;
- (void)removeAddressComponents:(NSSet*)value_;
- (void)addAddressComponentsObject:(LjsGoogleAddressComponentGeocode*)value_;
- (void)removeAddressComponentsObject:(LjsGoogleAddressComponentGeocode*)value_;

- (void)addTypes:(NSSet*)value_;
- (void)removeTypes:(NSSet*)value_;
- (void)addTypesObject:(LjsGoogleReverseGeocodeType*)value_;
- (void)removeTypesObject:(LjsGoogleReverseGeocodeType*)value_;

@end

@interface _LjsGoogleReverseGeocode (CoreDataGeneratedPrimitiveAccessors)


- (NSDate *)primitiveDateAdded;
- (void)setPrimitiveDateAdded:(NSDate *)value;




- (NSDate *)primitiveDateModified;
- (void)setPrimitiveDateModified:(NSDate *)value;




- (NSString *)primitiveFormattedAddress;
- (void)setPrimitiveFormattedAddress:(NSString *)value;




- (NSString *)primitiveKey;
- (void)setPrimitiveKey:(NSString *)value;




- (NSDecimalNumber *)primitiveLatitude100m;
- (void)setPrimitiveLatitude100m:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLatitude1km;
- (void)setPrimitiveLatitude1km:(NSDecimalNumber *)value;




- (id)primitiveLocation;
- (void)setPrimitiveLocation:(id)value;




- (id)primitiveLocation100m;
- (void)setPrimitiveLocation100m:(id)value;




- (NSString *)primitiveLocationType;
- (void)setPrimitiveLocationType:(NSString *)value;




- (NSDecimalNumber *)primitiveLongitude100m;
- (void)setPrimitiveLongitude100m:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLongitude1km;
- (void)setPrimitiveLongitude1km:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(NSDecimalNumber *)value;





- (NSMutableSet*)primitiveAddressComponents;
- (void)setPrimitiveAddressComponents:(NSMutableSet*)value;



- (LjsGoogleBounds*)primitiveBounds;
- (void)setPrimitiveBounds:(LjsGoogleBounds*)value;



- (NSMutableSet*)primitiveTypes;
- (void)setPrimitiveTypes:(NSMutableSet*)value;



- (LjsGoogleViewport*)primitiveViewport;
- (void)setPrimitiveViewport:(LjsGoogleViewport*)value;


@end
