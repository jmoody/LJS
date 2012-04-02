// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlaceDetails.m instead.

#import "_LjsGooglePlaceDetails.h"

const struct LjsGooglePlaceDetailsAttributes LjsGooglePlaceDetailsAttributes = {
	.dateAdded = @"dateAdded",
	.dateModified = @"dateModified",
	.formattedAddress = @"formattedAddress",
	.formattedPhone = @"formattedPhone",
	.iconUrl = @"iconUrl",
	.internationalPhone = @"internationalPhone",
	.location = @"location",
	.mapUrl = @"mapUrl",
	.name = @"name",
	.orderValue = @"orderValue",
	.rating = @"rating",
	.referenceId = @"referenceId",
	.stableId = @"stableId",
	.vicinity = @"vicinity",
	.website = @"website",
};

const struct LjsGooglePlaceDetailsRelationships LjsGooglePlaceDetailsRelationships = {
	.addressComponents = @"addressComponents",
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




@dynamic dateAdded;






@dynamic dateModified;






@dynamic formattedAddress;






@dynamic formattedPhone;






@dynamic iconUrl;






@dynamic internationalPhone;






@dynamic location;






@dynamic mapUrl;






@dynamic name;






@dynamic orderValue;






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
