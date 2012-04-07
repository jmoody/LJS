// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAddressComponentGeocode.h instead.

#import <CoreData/CoreData.h>
#import "LjsGoogleAddressComponent.h"

extern const struct LjsGoogleAddressComponentGeocodeAttributes {
} LjsGoogleAddressComponentGeocodeAttributes;

extern const struct LjsGoogleAddressComponentGeocodeRelationships {
	__unsafe_unretained NSString *geocode;
} LjsGoogleAddressComponentGeocodeRelationships;

extern const struct LjsGoogleAddressComponentGeocodeFetchedProperties {
} LjsGoogleAddressComponentGeocodeFetchedProperties;

@class LjsGoogleReverseGeocode;


@interface LjsGoogleAddressComponentGeocodeID : NSManagedObjectID {}
@end

@interface _LjsGoogleAddressComponentGeocode : LjsGoogleAddressComponent {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LjsGoogleAddressComponentGeocodeID*)objectID;





@property (nonatomic, strong) LjsGoogleReverseGeocode* geocode;

//- (BOOL)validateGeocode:(id*)value_ error:(NSError**)error_;





@end

@interface _LjsGoogleAddressComponentGeocode (CoreDataGeneratedAccessors)

@end

@interface _LjsGoogleAddressComponentGeocode (CoreDataGeneratedPrimitiveAccessors)



- (LjsGoogleReverseGeocode*)primitiveGeocode;
- (void)setPrimitiveGeocode:(LjsGoogleReverseGeocode*)value;


@end
