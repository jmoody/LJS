// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleViewport.m instead.

#import "_LjsGoogleViewport.h"

const struct LjsGoogleViewportAttributes LjsGoogleViewportAttributes = {
};

const struct LjsGoogleViewportRelationships LjsGoogleViewportRelationships = {
	.reverseGeocode = @"reverseGeocode",
};

const struct LjsGoogleViewportFetchedProperties LjsGoogleViewportFetchedProperties = {
};

@implementation LjsGoogleViewportID
@end

@implementation _LjsGoogleViewport

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleViewport" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleViewport";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleViewport" inManagedObjectContext:moc_];
}

- (LjsGoogleViewportID*)objectID {
	return (LjsGoogleViewportID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic reverseGeocode;

	






@end
