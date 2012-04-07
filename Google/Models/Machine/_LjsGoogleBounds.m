// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleBounds.m instead.

#import "_LjsGoogleBounds.h"

const struct LjsGoogleBoundsAttributes LjsGoogleBoundsAttributes = {
};

const struct LjsGoogleBoundsRelationships LjsGoogleBoundsRelationships = {
	.reverseGeocode = @"reverseGeocode",
};

const struct LjsGoogleBoundsFetchedProperties LjsGoogleBoundsFetchedProperties = {
};

@implementation LjsGoogleBoundsID
@end

@implementation _LjsGoogleBounds

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleBounds" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleBounds";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleBounds" inManagedObjectContext:moc_];
}

- (LjsGoogleBoundsID*)objectID {
	return (LjsGoogleBoundsID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic reverseGeocode;

	






@end
