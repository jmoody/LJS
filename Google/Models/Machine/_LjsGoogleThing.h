// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleThing.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleThingAttributes {
	__unsafe_unretained NSString *dateAdded;
	__unsafe_unretained NSString *dateModified;
	__unsafe_unretained NSString *formattedAddress;
	__unsafe_unretained NSString *orderValueNumber;
} LjsGoogleThingAttributes;

extern const struct LjsGoogleThingRelationships {
	__unsafe_unretained NSString *locationEnity;
} LjsGoogleThingRelationships;

extern const struct LjsGoogleThingFetchedProperties {
} LjsGoogleThingFetchedProperties;

@class LjsGoogleLocation;






@interface LjsGoogleThingID : NSManagedObjectID {}
@end

@interface _LjsGoogleThing : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleThingID*)objectID;




@property (nonatomic, strong) NSDate *dateAdded;


//- (BOOL)validateDateAdded:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate *dateModified;


//- (BOOL)validateDateModified:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *formattedAddress;


//- (BOOL)validateFormattedAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *orderValueNumber;


//- (BOOL)validateOrderValueNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) LjsGoogleLocation* locationEnity;

//- (BOOL)validateLocationEnity:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleThing (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleThing (CoreDataGeneratedPrimitiveAccessors)


- (NSDate *)primitiveDateAdded;
- (void)setPrimitiveDateAdded:(NSDate *)value;




- (NSDate *)primitiveDateModified;
- (void)setPrimitiveDateModified:(NSDate *)value;




- (NSString *)primitiveFormattedAddress;
- (void)setPrimitiveFormattedAddress:(NSString *)value;




- (NSDecimalNumber *)primitiveOrderValueNumber;
- (void)setPrimitiveOrderValueNumber:(NSDecimalNumber *)value;





- (LjsGoogleLocation*)primitiveLocationEnity;
- (void)setPrimitiveLocationEnity:(LjsGoogleLocation*)value;


@end
