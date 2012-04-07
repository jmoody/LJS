// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleBounds.h instead.

#import <CoreData/CoreData.h>
#import "LjsGoogleRect.h"

extern const struct LjsGoogleBoundsAttributes {
} LjsGoogleBoundsAttributes;

extern const struct LjsGoogleBoundsRelationships {
	__unsafe_unretained NSString *reverseGeocode;
} LjsGoogleBoundsRelationships;

extern const struct LjsGoogleBoundsFetchedProperties {
} LjsGoogleBoundsFetchedProperties;

@class LjsGoogleReverseGeocode;


@interface LjsGoogleBoundsID : NSManagedObjectID {}
@end

@interface _LjsGoogleBounds : LjsGoogleRect {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleBoundsID*)objectID;





@property (nonatomic, strong) LjsGoogleReverseGeocode* reverseGeocode;

//- (BOOL)validateReverseGeocode:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleBounds (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleBounds (CoreDataGeneratedPrimitiveAccessors)



- (LjsGoogleReverseGeocode*)primitiveReverseGeocode;
- (void)setPrimitiveReverseGeocode:(LjsGoogleReverseGeocode*)value;


@end
