// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogWithLoc.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogWithLocAttributes {
} LjsGoogWithLocAttributes;

extern const struct LjsGoogWithLocRelationships {
	__unsafe_unretained NSString *locationEnity;
} LjsGoogWithLocRelationships;

extern const struct LjsGoogWithLocFetchedProperties {
} LjsGoogWithLocFetchedProperties;

@class LjsGoogleLocation;


@interface LjsGoogWithLocID : NSManagedObjectID {}
@end

@interface _LjsGoogWithLoc : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogWithLocID*)objectID;





@property (nonatomic, strong) LjsGoogleLocation* locationEnity;

//- (BOOL)validateLocationEnity:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogWithLoc (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogWithLoc (CoreDataGeneratedPrimitiveAccessors)



- (LjsGoogleLocation*)primitiveLocationEnity;
- (void)setPrimitiveLocationEnity:(LjsGoogleLocation*)value;


@end
