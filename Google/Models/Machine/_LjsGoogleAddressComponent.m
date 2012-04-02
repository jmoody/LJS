// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAddressComponent.m instead.

#import "_LjsGoogleAddressComponent.h"

const struct LjsGoogleAddressComponentAttributes LjsGoogleAddressComponentAttributes = {
	.longName = @"longName",
	.shortName = @"shortName",
};

const struct LjsGoogleAddressComponentRelationships LjsGoogleAddressComponentRelationships = {
	.types = @"types",
};

const struct LjsGoogleAddressComponentFetchedProperties LjsGoogleAddressComponentFetchedProperties = {
};

@implementation LjsGoogleAddressComponentID
@end

@implementation _LjsGoogleAddressComponent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleAddressComponent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleAddressComponent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleAddressComponent" inManagedObjectContext:moc_];
}

- (LjsGoogleAddressComponentID*)objectID {
	return (LjsGoogleAddressComponentID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic longName;






@dynamic shortName;






@dynamic types;

	
- (NSMutableSet*)typesSet {
	[self willAccessValueForKey:@"types"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"types"];
  
	[self didAccessValueForKey:@"types"];
	return result;
}
	






@end
