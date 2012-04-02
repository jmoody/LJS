// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlaceDetails.m instead.

#import "_LjsGooglePlaceDetails.h"

const struct LjsGooglePlaceDetailsAttributes LjsGooglePlaceDetailsAttributes = {
	.formattedPhone = @"formattedPhone",
	.iconUrl = @"iconUrl",
	.internationalPhone = @"internationalPhone",
	.mapUrl = @"mapUrl",
	.name = @"name",
	.rating = @"rating",
	.referenceId = @"referenceId",
	.stableId = @"stableId",
	.vicinity = @"vicinity",
	.website = @"website",
};

const struct LjsGooglePlaceDetailsRelationships LjsGooglePlaceDetailsRelationships = {
	.attributions = @"attributions",
	.types = @"types",
};

const struct LjsGooglePlaceDetailsFetchedProperties LjsGooglePlaceDetailsFetchedProperties = {
};

@implementation LjsGooglePlaceDetailsID
@end

@implementation _LjsGooglePlaceDetails

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGooglePlaceDetails" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGooglePlaceDetails";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGooglePlaceDetails" inManagedObjectContext:moc_];
}

- (LjsGooglePlaceDetailsID*)objectID {
	return (LjsGooglePlaceDetailsID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic formattedPhone;






@dynamic iconUrl;






@dynamic internationalPhone;






@dynamic mapUrl;






@dynamic name;






@dynamic rating;






@dynamic referenceId;






@dynamic stableId;






@dynamic vicinity;






@dynamic website;






@dynamic attributions;

	
- (NSMutableSet*)attributionsSet {
	[self willAccessValueForKey:@"attributions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"attributions"];
  
	[self didAccessValueForKey:@"attributions"];
	return result;
}
	

@dynamic types;

	
- (NSMutableSet*)typesSet {
	[self willAccessValueForKey:@"types"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"types"];
  
	[self didAccessValueForKey:@"types"];
	return result;
}
	






@end
