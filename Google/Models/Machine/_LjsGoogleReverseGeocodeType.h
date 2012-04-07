// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleReverseGeocodeType.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleReverseGeocodeTypeAttributes {
	__unsafe_unretained NSString *name;
} LjsGoogleReverseGeocodeTypeAttributes;

extern const struct LjsGoogleReverseGeocodeTypeRelationships {
	__unsafe_unretained NSString *geocodes;
} LjsGoogleReverseGeocodeTypeRelationships;

extern const struct LjsGoogleReverseGeocodeTypeFetchedProperties {
} LjsGoogleReverseGeocodeTypeFetchedProperties;

@class LjsGoogleReverseGeocode;



@interface LjsGoogleReverseGeocodeTypeID : NSManagedObjectID {}
@end

@interface _LjsGoogleReverseGeocodeType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleReverseGeocodeTypeID*)objectID;




@property (nonatomic, strong) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* geocodes;

- (NSMutableSet*)geocodesSet;





@end

@interface _LjsGoogleReverseGeocodeType (CoreDataGeneratedAccessors)

- (void)addGeocodes:(NSSet*)value_;
- (void)removeGeocodes:(NSSet*)value_;
- (void)addGeocodesObject:(LjsGoogleReverseGeocode*)value_;
- (void)removeGeocodesObject:(LjsGoogleReverseGeocode*)value_;

@end

@interface _LjsGoogleReverseGeocodeType (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;





- (NSMutableSet*)primitiveGeocodes;
- (void)setPrimitiveGeocodes:(NSMutableSet*)value;


@end
