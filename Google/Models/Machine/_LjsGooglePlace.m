// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlace.m instead.

#import "_LjsGooglePlace.h"

const struct LjsGooglePlaceAttributes LjsGooglePlaceAttributes = {
	.dateAdded = @"dateAdded",
	.dateModified = @"dateModified",
	.formattedAddress = @"formattedAddress",
	.location = @"location",
	.orderValue = @"orderValue",
};

const struct LjsGooglePlaceRelationships LjsGooglePlaceRelationships = {
	.addressComponents = @"addressComponents",
};

const struct LjsGooglePlaceFetchedProperties LjsGooglePlaceFetchedProperties = {
};

@implementation LjsGooglePlaceID
@end

@implementation _LjsGooglePlace

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGooglePlace" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGooglePlace";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGooglePlace" inManagedObjectContext:moc_];
}

- (LjsGooglePlaceID*)objectID {
	return (LjsGooglePlaceID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic dateAdded;






@dynamic dateModified;






@dynamic formattedAddress;






@dynamic location;






@dynamic orderValue;






@dynamic addressComponents;

	
- (NSMutableSet*)addressComponentsSet {
	[self willAccessValueForKey:@"addressComponents"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"addressComponents"];
  
	[self didAccessValueForKey:@"addressComponents"];
	return result;
}
	






@end
