// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogBase.h instead.

#import <CoreData/CoreData.h>
#import "LjsGoogWithLoc.h"

extern const struct LjsGoogBaseAttributes {
	__unsafe_unretained NSString *dateAdded;
	__unsafe_unretained NSString *dateModified;
	__unsafe_unretained NSString *formattedAddress;
} LjsGoogBaseAttributes;

extern const struct LjsGoogBaseRelationships {
} LjsGoogBaseRelationships;

extern const struct LjsGoogBaseFetchedProperties {
} LjsGoogBaseFetchedProperties;






@interface LjsGoogBaseID : NSManagedObjectID {}
@end

@interface _LjsGoogBase : LjsGoogWithLoc {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogBaseID*)objectID;




@property (nonatomic, strong) NSDate *dateAdded;


//- (BOOL)validateDateAdded:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate *dateModified;


//- (BOOL)validateDateModified:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *formattedAddress;


//- (BOOL)validateFormattedAddress:(id*)value_ error:(NSError**)error_;






@end

@interface _LjsGoogBase (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogBase (CoreDataGeneratedPrimitiveAccessors)


- (NSDate *)primitiveDateAdded;
- (void)setPrimitiveDateAdded:(NSDate *)value;




- (NSDate *)primitiveDateModified;
- (void)setPrimitiveDateModified:(NSDate *)value;




- (NSString *)primitiveFormattedAddress;
- (void)setPrimitiveFormattedAddress:(NSString *)value;




@end
