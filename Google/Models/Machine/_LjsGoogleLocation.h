// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleLocation.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleLocationAttributes {
	__unsafe_unretained NSString *latitude100km;
	__unsafe_unretained NSString *latitude100m;
	__unsafe_unretained NSString *latitude10km;
	__unsafe_unretained NSString *latitude10m;
	__unsafe_unretained NSString *latitude1km;
	__unsafe_unretained NSString *latitude1m;
	__unsafe_unretained NSString *latitudeNumber;
	__unsafe_unretained NSString *longitude100km;
	__unsafe_unretained NSString *longitude100m;
	__unsafe_unretained NSString *longitude10km;
	__unsafe_unretained NSString *longitude10m;
	__unsafe_unretained NSString *longitude1km;
	__unsafe_unretained NSString *longitude1m;
	__unsafe_unretained NSString *longitudeNumber;
	__unsafe_unretained NSString *type;
} LjsGoogleLocationAttributes;

extern const struct LjsGoogleLocationRelationships {
	__unsafe_unretained NSString *thing;
} LjsGoogleLocationRelationships;

extern const struct LjsGoogleLocationFetchedProperties {
} LjsGoogleLocationFetchedProperties;

@class LjsGoogleThing;

















@interface LjsGoogleLocationID : NSManagedObjectID {}
@end

@interface _LjsGoogleLocation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleLocationID*)objectID;




@property (nonatomic, strong) NSNumber *latitude100km;


@property double latitude100kmValue;
- (double)latitude100kmValue;
- (void)setLatitude100kmValue:(double)value_;

//- (BOOL)validateLatitude100km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *latitude100m;


@property double latitude100mValue;
- (double)latitude100mValue;
- (void)setLatitude100mValue:(double)value_;

//- (BOOL)validateLatitude100m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *latitude10km;


@property double latitude10kmValue;
- (double)latitude10kmValue;
- (void)setLatitude10kmValue:(double)value_;

//- (BOOL)validateLatitude10km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *latitude10m;


@property double latitude10mValue;
- (double)latitude10mValue;
- (void)setLatitude10mValue:(double)value_;

//- (BOOL)validateLatitude10m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *latitude1km;


@property double latitude1kmValue;
- (double)latitude1kmValue;
- (void)setLatitude1kmValue:(double)value_;

//- (BOOL)validateLatitude1km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *latitude1m;


@property double latitude1mValue;
- (double)latitude1mValue;
- (void)setLatitude1mValue:(double)value_;

//- (BOOL)validateLatitude1m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *latitudeNumber;


@property double latitudeNumberValue;
- (double)latitudeNumberValue;
- (void)setLatitudeNumberValue:(double)value_;

//- (BOOL)validateLatitudeNumber:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *longitude100km;


@property double longitude100kmValue;
- (double)longitude100kmValue;
- (void)setLongitude100kmValue:(double)value_;

//- (BOOL)validateLongitude100km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *longitude100m;


@property double longitude100mValue;
- (double)longitude100mValue;
- (void)setLongitude100mValue:(double)value_;

//- (BOOL)validateLongitude100m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *longitude10km;


@property double longitude10kmValue;
- (double)longitude10kmValue;
- (void)setLongitude10kmValue:(double)value_;

//- (BOOL)validateLongitude10km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *longitude10m;


@property double longitude10mValue;
- (double)longitude10mValue;
- (void)setLongitude10mValue:(double)value_;

//- (BOOL)validateLongitude10m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *longitude1km;


@property double longitude1kmValue;
- (double)longitude1kmValue;
- (void)setLongitude1kmValue:(double)value_;

//- (BOOL)validateLongitude1km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *longitude1m;


@property double longitude1mValue;
- (double)longitude1mValue;
- (void)setLongitude1mValue:(double)value_;

//- (BOOL)validateLongitude1m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *longitudeNumber;


@property double longitudeNumberValue;
- (double)longitudeNumberValue;
- (void)setLongitudeNumberValue:(double)value_;

//- (BOOL)validateLongitudeNumber:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *type;


//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) LjsGoogleThing* thing;

//- (BOOL)validateThing:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleLocation (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleLocation (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber *)primitiveLatitude100km;
- (void)setPrimitiveLatitude100km:(NSNumber *)value;

- (double)primitiveLatitude100kmValue;
- (void)setPrimitiveLatitude100kmValue:(double)value_;




- (NSNumber *)primitiveLatitude100m;
- (void)setPrimitiveLatitude100m:(NSNumber *)value;

- (double)primitiveLatitude100mValue;
- (void)setPrimitiveLatitude100mValue:(double)value_;




- (NSNumber *)primitiveLatitude10km;
- (void)setPrimitiveLatitude10km:(NSNumber *)value;

- (double)primitiveLatitude10kmValue;
- (void)setPrimitiveLatitude10kmValue:(double)value_;




- (NSNumber *)primitiveLatitude10m;
- (void)setPrimitiveLatitude10m:(NSNumber *)value;

- (double)primitiveLatitude10mValue;
- (void)setPrimitiveLatitude10mValue:(double)value_;




- (NSNumber *)primitiveLatitude1km;
- (void)setPrimitiveLatitude1km:(NSNumber *)value;

- (double)primitiveLatitude1kmValue;
- (void)setPrimitiveLatitude1kmValue:(double)value_;




- (NSNumber *)primitiveLatitude1m;
- (void)setPrimitiveLatitude1m:(NSNumber *)value;

- (double)primitiveLatitude1mValue;
- (void)setPrimitiveLatitude1mValue:(double)value_;




- (NSNumber *)primitiveLatitudeNumber;
- (void)setPrimitiveLatitudeNumber:(NSNumber *)value;

- (double)primitiveLatitudeNumberValue;
- (void)setPrimitiveLatitudeNumberValue:(double)value_;




- (NSNumber *)primitiveLongitude100km;
- (void)setPrimitiveLongitude100km:(NSNumber *)value;

- (double)primitiveLongitude100kmValue;
- (void)setPrimitiveLongitude100kmValue:(double)value_;




- (NSNumber *)primitiveLongitude100m;
- (void)setPrimitiveLongitude100m:(NSNumber *)value;

- (double)primitiveLongitude100mValue;
- (void)setPrimitiveLongitude100mValue:(double)value_;




- (NSNumber *)primitiveLongitude10km;
- (void)setPrimitiveLongitude10km:(NSNumber *)value;

- (double)primitiveLongitude10kmValue;
- (void)setPrimitiveLongitude10kmValue:(double)value_;




- (NSNumber *)primitiveLongitude10m;
- (void)setPrimitiveLongitude10m:(NSNumber *)value;

- (double)primitiveLongitude10mValue;
- (void)setPrimitiveLongitude10mValue:(double)value_;




- (NSNumber *)primitiveLongitude1km;
- (void)setPrimitiveLongitude1km:(NSNumber *)value;

- (double)primitiveLongitude1kmValue;
- (void)setPrimitiveLongitude1kmValue:(double)value_;




- (NSNumber *)primitiveLongitude1m;
- (void)setPrimitiveLongitude1m:(NSNumber *)value;

- (double)primitiveLongitude1mValue;
- (void)setPrimitiveLongitude1mValue:(double)value_;




- (NSNumber *)primitiveLongitudeNumber;
- (void)setPrimitiveLongitudeNumber:(NSNumber *)value;

- (double)primitiveLongitudeNumberValue;
- (void)setPrimitiveLongitudeNumberValue:(double)value_;




- (NSString *)primitiveType;
- (void)setPrimitiveType:(NSString *)value;





- (LjsGoogleThing*)primitiveThing;
- (void)setPrimitiveThing:(LjsGoogleThing*)value;


@end
