// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleReverseGeocode.h instead.

#import <CoreData/CoreData.h>
#import "LjsGooglePlace.h"

extern const struct LjsGoogleReverseGeocodeAttributes {
	__unsafe_unretained NSString *location100m;
} LjsGoogleReverseGeocodeAttributes;

extern const struct LjsGoogleReverseGeocodeRelationships {
	__unsafe_unretained NSString *bounds;
	__unsafe_unretained NSString *viewport;
} LjsGoogleReverseGeocodeRelationships;

extern const struct LjsGoogleReverseGeocodeFetchedProperties {
} LjsGoogleReverseGeocodeFetchedProperties;

@class LjsGoogleBounds;
@class LjsGoogleViewport;

@class NSObject;

@interface LjsGoogleReverseGeocodeID : NSManagedObjectID {}
@end

@interface _LjsGoogleReverseGeocode : LjsGooglePlace {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleReverseGeocodeID*)objectID;




@property (nonatomic, strong) id location100m;


//- (BOOL)validateLocation100m:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) LjsGoogleBounds* bounds;

//- (BOOL)validateBounds:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) LjsGoogleViewport* viewport;

//- (BOOL)validateViewport:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleReverseGeocode (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleReverseGeocode (CoreDataGeneratedPrimitiveAccessors)


- (id)primitiveLocation100m;
- (void)setPrimitiveLocation100m:(id)value;





- (LjsGoogleBounds*)primitiveBounds;
- (void)setPrimitiveBounds:(LjsGoogleBounds*)value;



- (LjsGoogleViewport*)primitiveViewport;
- (void)setPrimitiveViewport:(LjsGoogleViewport*)value;


@end
