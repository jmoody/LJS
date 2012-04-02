// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlaceDetailsType.m instead.

#import "_LjsGooglePlaceDetailsType.h"

const struct LjsGooglePlaceDetailsTypeAttributes LjsGooglePlaceDetailsTypeAttributes = {
	.name = @"name",
};

const struct LjsGooglePlaceDetailsTypeRelationships LjsGooglePlaceDetailsTypeRelationships = {
	.places = @"places",
};

const struct LjsGooglePlaceDetailsTypeFetchedProperties LjsGooglePlaceDetailsTypeFetchedProperties = {
};

@implementation LjsGooglePlaceDetailsTypeID
@end

@implementation _LjsGooglePlaceDetailsType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGooglePlaceDetailsType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGooglePlaceDetailsType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGooglePlaceDetailsType" inManagedObjectContext:moc_];
}

- (LjsGooglePlaceDetailsTypeID*)objectID {
	return (LjsGooglePlaceDetailsTypeID*)[super objectID];
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
