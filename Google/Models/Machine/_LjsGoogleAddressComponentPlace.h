// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAddressComponentPlace.h instead.

#import <CoreData/CoreData.h>
#import "LjsGoogleAddressComponent.h"

extern const struct LjsGoogleAddressComponentPlaceAttributes {
} LjsGoogleAddressComponentPlaceAttributes;

extern const struct LjsGoogleAddressComponentPlaceRelationships {
	__unsafe_unretained NSString *place;
} LjsGoogleAddressComponentPlaceRelationships;

extern const struct LjsGoogleAddressComponentPlaceFetchedProperties {
} LjsGoogleAddressComponentPlaceFetchedProperties;

@class LjsGooglePlace;


@interface LjsGoogleAddressComponentPlaceID : NSManagedObjectID {}
@end

@interface _LjsGoogleAddressComponentPlace : LjsGoogleAddressComponent {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleAddressComponentPlaceID*)objectID;





@property (nonatomic, strong) LjsGooglePlace* place;

//- (BOOL)validatePlace:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleAddressComponentPlace (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleAddressComponentPlace (CoreDataGeneratedPrimitiveAccessors)



- (LjsGooglePlace*)primitivePlace;
- (void)setPrimitivePlace:(LjsGooglePlace*)value;


@end
