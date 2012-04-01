// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleLocation.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleLocationAttributes {
	__unsafe_unretained NSString *latitudeNumber;
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




@property (nonatomic, strong) NSNumber *latitudeNumber;


@property double latitudeNumberValue;
- (double)latitudeNumberValue;
- (void)setLatitudeNumberValue:(double)value_;

//- (BOOL)validateLatitudeNumber:(id*)value_ error:(NSError**)error_;




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


- (NSNumber *)primitiveLatitudeNumber;
- (void)setPrimitiveLatitudeNumber:(NSNumber *)value;

- (double)primitiveLatitudeNumberValue;
- (void)setPrimitiveLatitudeNumberValue:(double)value_;




- (NSNumber *)primitiveLongitudeNumber;
- (void)setPrimitiveLongitudeNumber:(NSNumber *)value;

- (double)primitiveLongitudeNumberValue;
- (void)setPrimitiveLongitudeNumberValue:(double)value_;




- (NSString *)primitiveType;
- (void)setPrimitiveType:(NSString *)value;





- (LjsGoogleThing*)primitiveThing;
- (void)setPrimitiveThing:(LjsGoogleThing*)value;


@end
