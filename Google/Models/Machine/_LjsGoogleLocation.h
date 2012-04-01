// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleLocation.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleLocationAttributes {
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *latitude100km;
	__unsafe_unretained NSString *latitude100m;
	__unsafe_unretained NSString *latitude10km;
	__unsafe_unretained NSString *latitude10m;
	__unsafe_unretained NSString *latitude1km;
	__unsafe_unretained NSString *latitude1m;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *longitude100km;
	__unsafe_unretained NSString *longitude100m;
	__unsafe_unretained NSString *longitude10km;
	__unsafe_unretained NSString *longitude10m;
	__unsafe_unretained NSString *longitude1km;
	__unsafe_unretained NSString *longitude1m;
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




@property (nonatomic, strong) NSDecimalNumber *latitude;


//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *latitude100km;


//- (BOOL)validateLatitude100km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *latitude100m;


//- (BOOL)validateLatitude100m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *latitude10km;


//- (BOOL)validateLatitude10km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *latitude10m;


//- (BOOL)validateLatitude10m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *latitude1km;


//- (BOOL)validateLatitude1km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *latitude1m;


//- (BOOL)validateLatitude1m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude;


//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude100km;


//- (BOOL)validateLongitude100km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude100m;


//- (BOOL)validateLongitude100m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude10km;


//- (BOOL)validateLongitude10km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude10m;


//- (BOOL)validateLongitude10m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude1km;


//- (BOOL)validateLongitude1km:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *longitude1m;


//- (BOOL)validateLongitude1m:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *type;


//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) LjsGoogleThing* thing;

//- (BOOL)validateThing:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleLocation (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleLocation (CoreDataGeneratedPrimitiveAccessors)


- (NSDecimalNumber *)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLatitude100km;
- (void)setPrimitiveLatitude100km:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLatitude100m;
- (void)setPrimitiveLatitude100m:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLatitude10km;
- (void)setPrimitiveLatitude10km:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLatitude10m;
- (void)setPrimitiveLatitude10m:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLatitude1km;
- (void)setPrimitiveLatitude1km:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLatitude1m;
- (void)setPrimitiveLatitude1m:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLongitude100km;
- (void)setPrimitiveLongitude100km:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLongitude100m;
- (void)setPrimitiveLongitude100m:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLongitude10km;
- (void)setPrimitiveLongitude10km:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLongitude10m;
- (void)setPrimitiveLongitude10m:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLongitude1km;
- (void)setPrimitiveLongitude1km:(NSDecimalNumber *)value;




- (NSDecimalNumber *)primitiveLongitude1m;
- (void)setPrimitiveLongitude1m:(NSDecimalNumber *)value;




- (NSString *)primitiveType;
- (void)setPrimitiveType:(NSString *)value;





- (LjsGoogleThing*)primitiveThing;
- (void)setPrimitiveThing:(LjsGoogleThing*)value;


@end
