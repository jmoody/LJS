// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleReverseGeocodeType.m instead.

#import "_LjsGoogleReverseGeocodeType.h"

const struct LjsGoogleReverseGeocodeTypeAttributes LjsGoogleReverseGeocodeTypeAttributes = {
	.name = @"name",
};

const struct LjsGoogleReverseGeocodeTypeRelationships LjsGoogleReverseGeocodeTypeRelationships = {
	.geocodes = @"geocodes",
};

const struct LjsGoogleReverseGeocodeTypeFetchedProperties LjsGoogleReverseGeocodeTypeFetchedProperties = {
};

@implementation LjsGoogleReverseGeocodeTypeID
@end

@implementation _LjsGoogleReverseGeocodeType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleReverseGeocodeType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleReverseGeocodeType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleReverseGeocodeType" inManagedObjectContext:moc_];
}

- (LjsGoogleReverseGeocodeTypeID*)objectID {
	return (LjsGoogleReverseGeocodeTypeID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic geocodes;

	
- (NSMutableSet*)geocodesSet {
	[self willAccessValueForKey:@"geocodes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"geocodes"];
  
	[self didAccessValueForKey:@"geocodes"];
	return result;
}
	






@end
