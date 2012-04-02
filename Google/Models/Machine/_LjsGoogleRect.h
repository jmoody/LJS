// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleRect.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleRectAttributes {
	__unsafe_unretained NSString *northeast;
	__unsafe_unretained NSString *southwest;
} LjsGoogleRectAttributes;

extern const struct LjsGoogleRectRelationships {
} LjsGoogleRectRelationships;

extern const struct LjsGoogleRectFetchedProperties {
} LjsGoogleRectFetchedProperties;


@class NSObject;
@class NSObject;

@interface LjsGoogleRectID : NSManagedObjectID {}
@end

@interface _LjsGoogleRect : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleRectID*)objectID;




@property (nonatomic, strong) id northeast;


//- (BOOL)validateNortheast:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id southwest;


//- (BOOL)validateSouthwest:(id*)value_ error:(NSError**)error_;






@end

@interface _LjsGoogleRect (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleRect (CoreDataGeneratedPrimitiveAccessors)


- (id)primitiveNortheast;
- (void)setPrimitiveNortheast:(id)value;




- (id)primitiveSouthwest;
- (void)setPrimitiveSouthwest:(id)value;




@end
