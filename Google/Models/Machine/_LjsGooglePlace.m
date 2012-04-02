// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlace.m instead.

#import "_LjsGooglePlace.h"

const struct LjsGooglePlaceAttributes LjsGooglePlaceAttributes = {
	.formattedPhone = @"formattedPhone",
	.iconUrl = @"iconUrl",
	.internationalPhone = @"internationalPhone",
	.mapUrl = @"mapUrl",
	.name = @"name",
	.orderValueNumber = @"orderValueNumber",
	.rating = @"rating",
	.referenceId = @"referenceId",
	.stableId = @"stableId",
	.vicinity = @"vicinity",
	.website = @"website",
};

const struct LjsGooglePlaceRelationships LjsGooglePlaceRelationships = {
	.addressComponents = @"addressComponents",
	.attributions = @"attributions",
	.types = @"types",
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




@dynamic formattedPhone;






@dynamic iconUrl;






@dynamic internationalPhone;






@dynamic mapUrl;






@dynamic name;






@dynamic orderValueNumber;






@dynamic rating;






@dynamic referenceId;






@dynamic stableId;






@dynamic vicinity;






@dynamic website;






@dynamic addressComponents;

	
- (NSMutableSet*)addressComponentsSet {
	[self willAccessValueForKey:@"addressComponents"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"addressComponents"];
  
	[self didAccessValueForKey:@"addressComponents"];
	return result;
}
	

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
