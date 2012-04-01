// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGooglePlace.m instead.

#import "_LjsGooglePlace.h"

const struct LjsGooglePlaceAttributes LjsGooglePlaceAttributes = {
	.formattedPhone = @"formattedPhone",
	.iconUrl = @"iconUrl",
	.internationalPhone = @"internationalPhone",
	.latitudeNumber = @"latitudeNumber",
	.longitudeNumber = @"longitudeNumber",
	.mapUrl = @"mapUrl",
	.name = @"name",
	.ratingNumber = @"ratingNumber",
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
	
	if ([key isEqualToString:@"latitudeNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitudeNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitudeNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitudeNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"ratingNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ratingNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic formattedPhone;






@dynamic iconUrl;






@dynamic internationalPhone;






@dynamic latitudeNumber;



- (double)latitudeNumberValue {
	NSNumber *result = [self latitudeNumber];
	return [result doubleValue];
}

- (void)setLatitudeNumberValue:(double)value_ {
	[self setLatitudeNumber:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeNumberValue {
	NSNumber *result = [self primitiveLatitudeNumber];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeNumberValue:(double)value_ {
	[self setPrimitiveLatitudeNumber:[NSNumber numberWithDouble:value_]];
}





@dynamic longitudeNumber;



- (double)longitudeNumberValue {
	NSNumber *result = [self longitudeNumber];
	return [result doubleValue];
}

- (void)setLongitudeNumberValue:(double)value_ {
	[self setLongitudeNumber:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeNumberValue {
	NSNumber *result = [self primitiveLongitudeNumber];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeNumberValue:(double)value_ {
	[self setPrimitiveLongitudeNumber:[NSNumber numberWithDouble:value_]];
}





@dynamic mapUrl;






@dynamic name;






@dynamic ratingNumber;



- (double)ratingNumberValue {
	NSNumber *result = [self ratingNumber];
	return [result doubleValue];
}

- (void)setRatingNumberValue:(double)value_ {
	[self setRatingNumber:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveRatingNumberValue {
	NSNumber *result = [self primitiveRatingNumber];
	return [result doubleValue];
}

- (void)setPrimitiveRatingNumberValue:(double)value_ {
	[self setPrimitiveRatingNumber:[NSNumber numberWithDouble:value_]];
}





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
