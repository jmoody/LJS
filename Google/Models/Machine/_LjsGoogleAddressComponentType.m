// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAddressComponentType.m instead.

#import "_LjsGoogleAddressComponentType.h"

const struct LjsGoogleAddressComponentTypeAttributes LjsGoogleAddressComponentTypeAttributes = {
	.name = @"name",
};

const struct LjsGoogleAddressComponentTypeRelationships LjsGoogleAddressComponentTypeRelationships = {
	.components = @"components",
};

const struct LjsGoogleAddressComponentTypeFetchedProperties LjsGoogleAddressComponentTypeFetchedProperties = {
};

@implementation LjsGoogleAddressComponentTypeID
@end

@implementation _LjsGoogleAddressComponentType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleAddressComponentType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleAddressComponentType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleAddressComponentType" inManagedObjectContext:moc_];
}

- (LjsGoogleAddressComponentTypeID*)objectID {
	return (LjsGoogleAddressComponentTypeID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic components;

	
- (NSMutableSet*)componentsSet {
	[self willAccessValueForKey:@"components"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"components"];
  
	[self didAccessValueForKey:@"components"];
	return result;
}
	






@end
