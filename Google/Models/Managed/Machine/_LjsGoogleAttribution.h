// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAttribution.h instead.

#import <CoreData/CoreData.h>


extern const struct LjsGoogleAttributionAttributes {
	__unsafe_unretained NSString *html;
} LjsGoogleAttributionAttributes;

extern const struct LjsGoogleAttributionRelationships {
	__unsafe_unretained NSString *places;
} LjsGoogleAttributionRelationships;

extern const struct LjsGoogleAttributionFetchedProperties {
} LjsGoogleAttributionFetchedProperties;

@class LjsGooglePlace;



@interface LjsGoogleAttributionID : NSManagedObjectID {}
@end

@interface _LjsGoogleAttribution : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleAttributionID*)objectID;




@property (nonatomic, strong) NSString *html;


//- (BOOL)validateHtml:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* places;

- (NSMutableSet*)placesSet;





@end

@interface _LjsGoogleAttribution (CoreDataGeneratedAccessors)

- (void)addPlaces:(NSSet*)value_;
- (void)removePlaces:(NSSet*)value_;
- (void)addPlacesObject:(LjsGooglePlace*)value_;
- (void)removePlacesObject:(LjsGooglePlace*)value_;

@end

@interface _LjsGoogleAttribution (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveHtml;
- (void)setPrimitiveHtml:(NSString *)value;





- (NSMutableSet*)primitivePlaces;
- (void)setPrimitivePlaces:(NSMutableSet*)value;


@end
