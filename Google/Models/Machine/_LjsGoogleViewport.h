// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleViewport.h instead.

#import <CoreData/CoreData.h>
#import "LjsGoogleRect.h"

extern const struct LjsGoogleViewportAttributes {
} LjsGoogleViewportAttributes;

extern const struct LjsGoogleViewportRelationships {
	__unsafe_unretained NSString *reverseGeocode;
} LjsGoogleViewportRelationships;

extern const struct LjsGoogleViewportFetchedProperties {
} LjsGoogleViewportFetchedProperties;

@class LjsGoogleReverseGeocode;


@interface LjsGoogleViewportID : NSManagedObjectID {}
@end

@interface _LjsGoogleViewport : LjsGoogleRect {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleViewportID*)objectID;





@property (nonatomic, strong) LjsGoogleReverseGeocode* reverseGeocode;

//- (BOOL)validateReverseGeocode:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleViewport (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleViewport (CoreDataGeneratedPrimitiveAccessors)



- (LjsGoogleReverseGeocode*)primitiveReverseGeocode;
- (void)setPrimitiveReverseGeocode:(LjsGoogleReverseGeocode*)value;


@end
