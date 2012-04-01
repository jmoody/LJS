// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlaceType.m instead.

#import "_LjsGooglePlaceType.h"

const struct LjsGooglePlaceTypeAttributes LjsGooglePlaceTypeAttributes = {
	.name = @"name",
};

const struct LjsGooglePlaceTypeRelationships LjsGooglePlaceTypeRelationships = {
	.places = @"places",
};

const struct LjsGooglePlaceTypeFetchedProperties LjsGooglePlaceTypeFetchedProperties = {
};

@implementation LjsGooglePlaceTypeID
@end

@implementation _LjsGooglePlaceType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGooglePlaceType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGooglePlaceType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGooglePlaceType" inManagedObjectContext:moc_];
}

- (LjsGooglePlaceTypeID*)objectID {
	return (LjsGooglePlaceTypeID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic places;

	
- (NSMutableSet*)placesSet {
	[self willAccessValueForKey:@"places"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"places"];
  
	[self didAccessValueForKey:@"places"];
	return result;
}
	






@end
