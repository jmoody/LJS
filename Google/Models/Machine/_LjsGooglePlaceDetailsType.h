// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlaceDetailsType.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGooglePlaceDetailsTypeAttributes {
	__unsafe_unretained NSString *name;
} LjsGooglePlaceDetailsTypeAttributes;

extern const struct LjsGooglePlaceDetailsTypeRelationships {
	__unsafe_unretained NSString *places;
} LjsGooglePlaceDetailsTypeRelationships;

extern const struct LjsGooglePlaceDetailsTypeFetchedProperties {
} LjsGooglePlaceDetailsTypeFetchedProperties;

@class LjsGooglePlaceDetails;



@interface LjsGooglePlaceDetailsTypeID : NSManagedObjectID {}
@end

@interface _LjsGooglePlaceDetailsType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGooglePlaceDetailsTypeID*)objectID;




@property (nonatomic, strong) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* places;

- (NSMutableSet*)placesSet;





@end

@interface _LjsGooglePlaceDetailsType (CoreDataGeneratedAccessors)

- (void)addPlaces:(NSSet*)value_;
- (void)removePlaces:(NSSet*)value_;
- (void)addPlacesObject:(LjsGooglePlaceDetails*)value_;
- (void)removePlacesObject:(LjsGooglePlaceDetails*)value_;

@end

@interface _LjsGooglePlaceDetailsType (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;





- (NSMutableSet*)primitivePlaces;
- (void)setPrimitivePlaces:(NSMutableSet*)value;


@end
