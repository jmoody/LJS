// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleReverseGeocode.m instead.

#import "_LjsGoogleReverseGeocode.h"

const struct LjsGoogleReverseGeocodeAttributes LjsGoogleReverseGeocodeAttributes = {
	.dateAdded = @"dateAdded",
	.dateModified = @"dateModified",
	.formattedAddress = @"formattedAddress",
	.key = @"key",
	.latitude100m = @"latitude100m",
	.latitude10m = @"latitude10m",
	.latitude1km = @"latitude1km",
	.latitude1m = @"latitude1m",
	.location = @"location",
	.location100m = @"location100m",
	.location10m = @"location10m",
	.location1m = @"location1m",
	.locationType = @"locationType",
	.longitude100m = @"longitude100m",
	.longitude10m = @"longitude10m",
	.longitude1km = @"longitude1km",
	.longitude1m = @"longitude1m",
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






@dynamic latitude10m;






@dynamic latitude1km;






@dynamic latitude1m;






@dynamic location;






@dynamic location100m;






@dynamic location10m;






@dynamic location1m;






@dynamic locationType;






@dynamic longitude100m;






@dynamic longitude10m;






@dynamic longitude1km;






@dynamic longitude1m;






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
