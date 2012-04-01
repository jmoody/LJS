// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlace.h instead.

#import <CoreData/CoreData.h>
#import "LjsGoogleThing.h"

extern const struct LjsGooglePlaceAttributes {
	__unsafe_unretained NSString *formattedPhone;
	__unsafe_unretained NSString *iconUrl;
	__unsafe_unretained NSString *internationalPhone;
	__unsafe_unretained NSString *mapUrl;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *rating;
	__unsafe_unretained NSString *referenceId;
	__unsafe_unretained NSString *stableId;
	__unsafe_unretained NSString *vicinity;
	__unsafe_unretained NSString *website;
} LjsGooglePlaceAttributes;

extern const struct LjsGooglePlaceRelationships {
	__unsafe_unretained NSString *addressComponents;
	__unsafe_unretained NSString *attributions;
	__unsafe_unretained NSString *types;
} LjsGooglePlaceRelationships;

extern const struct LjsGooglePlaceFetchedProperties {
} LjsGooglePlaceFetchedProperties;

@class LjsGoogleAddressComponent;
@class LjsGoogleAttribution;
@class LjsGooglePlaceType;












@interface LjsGooglePlaceID : NSManagedObjectID {}
@end

@interface _LjsGooglePlace : LjsGoogleThing {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGooglePlaceID*)objectID;




@property (nonatomic, strong) NSString *formattedPhone;


//- (BOOL)validateFormattedPhone:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *iconUrl;


//- (BOOL)validateIconUrl:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *internationalPhone;


//- (BOOL)validateInternationalPhone:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *mapUrl;


//- (BOOL)validateMapUrl:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *rating;


//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *referenceId;


//- (BOOL)validateReferenceId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *stableId;


//- (BOOL)validateStableId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *vicinity;


//- (BOOL)validateVicinity:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *website;


//- (BOOL)validateWebsite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* addressComponents;

- (NSMutableSet*)addressComponentsSet;




@property (nonatomic, strong) NSSet* attributions;

- (NSMutableSet*)attributionsSet;




@property (nonatomic, strong) NSSet* types;

- (NSMutableSet*)typesSet;





@end

@interface _LjsGooglePlace (CoreDataGeneratedAccessors)

- (void)addAddressComponents:(NSSet*)value_;
- (void)removeAddressComponents:(NSSet*)value_;
- (void)addAddressComponentsObject:(LjsGoogleAddressComponent*)value_;
- (void)removeAddressComponentsObject:(LjsGoogleAddressComponent*)value_;

- (void)addAttributions:(NSSet*)value_;
- (void)removeAttributions:(NSSet*)value_;
- (void)addAttributionsObject:(LjsGoogleAttribution*)value_;
- (void)removeAttributionsObject:(LjsGoogleAttribution*)value_;

- (void)addTypes:(NSSet*)value_;
- (void)removeTypes:(NSSet*)value_;
- (void)addTypesObject:(LjsGooglePlaceType*)value_;
- (void)removeTypesObject:(LjsGooglePlaceType*)value_;

@end

@interface _LjsGooglePlace (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveFormattedPhone;
- (void)setPrimitiveFormattedPhone:(NSString *)value;




- (NSString *)primitiveIconUrl;
- (void)setPrimitiveIconUrl:(NSString *)value;




- (NSString *)primitiveInternationalPhone;
- (void)setPrimitiveInternationalPhone:(NSString *)value;




- (NSString *)primitiveMapUrl;
- (void)setPrimitiveMapUrl:(NSString *)value;




- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;




- (NSDecimalNumber *)primitiveRating;
- (void)setPrimitiveRating:(NSDecimalNumber *)value;




- (NSString *)primitiveReferenceId;
- (void)setPrimitiveReferenceId:(NSString *)value;




- (NSString *)primitiveStableId;
- (void)setPrimitiveStableId:(NSString *)value;




- (NSString *)primitiveVicinity;
- (void)setPrimitiveVicinity:(NSString *)value;




- (NSString *)primitiveWebsite;
- (void)setPrimitiveWebsite:(NSString *)value;





- (NSMutableSet*)primitiveAddressComponents;
- (void)setPrimitiveAddressComponents:(NSMutableSet*)value;



- (NSMutableSet*)primitiveAttributions;
- (void)setPrimitiveAttributions:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTypes;
- (void)setPrimitiveTypes:(NSMutableSet*)value;


@end
