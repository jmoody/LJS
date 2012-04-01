// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleLocation.m instead.

#import "_LjsGoogleLocation.h"

const struct LjsGoogleLocationAttributes LjsGoogleLocationAttributes = {
	.latitudeNumber = @"latitudeNumber",
	.longitudeNumber = @"longitudeNumber",
	.type = @"type",
};

const struct LjsGoogleLocationRelationships LjsGoogleLocationRelationships = {
	.thing = @"thing",
};

const struct LjsGoogleLocationFetchedProperties LjsGoogleLocationFetchedProperties = {
};

@implementation LjsGoogleLocationID
@end

@implementation _LjsGoogleLocation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleLocation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleLocation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleLocation" inManagedObjectContext:moc_];
}

- (LjsGoogleLocationID*)objectID {
	return (LjsGoogleLocationID*)[super objectID];
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

	return keyPaths;
}




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





@dynamic type;






@dynamic thing;

	






@end
