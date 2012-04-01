// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAttribution.m instead.

#import "_LjsGoogleAttribution.h"

const struct LjsGoogleAttributionAttributes LjsGoogleAttributionAttributes = {
	.html = @"html",
};

const struct LjsGoogleAttributionRelationships LjsGoogleAttributionRelationships = {
	.places = @"places",
};

const struct LjsGoogleAttributionFetchedProperties LjsGoogleAttributionFetchedProperties = {
};

@implementation LjsGoogleAttributionID
@end

@implementation _LjsGoogleAttribution

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleAttribution" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleAttribution";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleAttribution" inManagedObjectContext:moc_];
}

- (LjsGoogleAttributionID*)objectID {
	return (LjsGoogleAttributionID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic html;






@dynamic places;

	
- (NSMutableSet*)placesSet {
	[self willAccessValueForKey:@"places"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"places"];
  
	[self didAccessValueForKey:@"places"];
	return result;
}
	






@end
