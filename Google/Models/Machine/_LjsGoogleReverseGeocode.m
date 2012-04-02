// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleReverseGeocode.m instead.

#import "_LjsGoogleReverseGeocode.h"

const struct LjsGoogleReverseGeocodeAttributes LjsGoogleReverseGeocodeAttributes = {
	.location100m = @"location100m",
	.locationType = @"locationType",
};

const struct LjsGoogleReverseGeocodeRelationships LjsGoogleReverseGeocodeRelationships = {
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




@dynamic location100m;






@dynamic locationType;






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
