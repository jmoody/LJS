// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleReverseGeocode.m instead.

#import "_LjsGoogleReverseGeocode.h"

const struct LjsGoogleReverseGeocodeAttributes LjsGoogleReverseGeocodeAttributes = {
	.dateAdded = @"dateAdded",
	.dateModified = @"dateModified",
	.formattedAddress = @"formattedAddress",
	.key = @"key",
	.latitude100m = @"latitude100m",
	.latitude1km = @"latitude1km",
	.location = @"location",
	.location100m = @"location100m",
	.locationType = @"locationType",
	.longitude100m = @"longitude100m",
	.longitude1km = @"longitude1km",
	.orderValue = @"orderValue",
};

const struct LjsGoogleReverseGeocodeRelationships LjsGoogleReverseGeocodeRelationships = {
	.addressComponents = @"addressComponents",
	.bounds = @"bounds",
	.types = @"types",
	.viewport = @"viewport",
};

const struct LjsGoogleReverseGeocodeFetchedProperties LjsGoogleReverseGeocodeFetchedProperties = {
};

@implementation LjsGoogleReverseGeocodeID
@end

@implementation _LjsGoogleReverseGeocode

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleReverseGeocode" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleReverseGeocode";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleReverseGeocode" inManagedObjectContext:moc_];
}

- (LjsGoogleReverseGeocodeID*)objectID {
	return (LjsGoogleReverseGeocodeID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic dateAdded;






@dynamic dateModified;






@dynamic formattedAddress;






@dynamic key;






@dynamic latitude100m;






@dynamic latitude1km;






@dynamic location;






@dynamic location100m;






@dynamic locationType;






@dynamic longitude100m;






@dynamic longitude1km;






@dynamic orderValue;






@dynamic addressComponents;

	
- (NSMutableSet*)addressComponentsSet {
	[self willAccessValueForKey:@"addressComponents"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"addressComponents"];
  
	[self didAccessValueForKey:@"addressComponents"];
	return result;
}
	

@dynamic bounds;

	

@dynamic types;

	
- (NSMutableSet*)typesSet {
	[self willAccessValueForKey:@"types"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"types"];
  
	[self didAccessValueForKey:@"types"];
	return result;
}
	

@dynamic viewport;

	






@end
