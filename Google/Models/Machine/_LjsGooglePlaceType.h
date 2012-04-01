// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlaceType.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGooglePlaceTypeAttributes {
	__unsafe_unretained NSString *name;
} LjsGooglePlaceTypeAttributes;

extern const struct LjsGooglePlaceTypeRelationships {
	__unsafe_unretained NSString *places;
} LjsGooglePlaceTypeRelationships;

extern const struct LjsGooglePlaceTypeFetchedProperties {
} LjsGooglePlaceTypeFetchedProperties;

@class LjsGooglePlace;



@interface LjsGooglePlaceTypeID : NSManagedObjectID {}
@end

@interface _LjsGooglePlaceType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGooglePlaceTypeID*)objectID;




@property (nonatomic, strong) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* places;

- (NSMutableSet*)placesSet;





@end

@interface _LjsGooglePlaceType (CoreDataGeneratedAccessors)

- (void)addPlaces:(NSSet*)value_;
- (void)removePlaces:(NSSet*)value_;
- (void)addPlacesObject:(LjsGooglePlace*)value_;
- (void)removePlacesObject:(LjsGooglePlace*)value_;

@end

@interface _LjsGooglePlaceType (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;





- (NSMutableSet*)primitivePlaces;
- (void)setPrimitivePlaces:(NSMutableSet*)value;


@end
