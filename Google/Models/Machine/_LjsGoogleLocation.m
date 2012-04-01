// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleLocation.m instead.

#import "_LjsGoogleLocation.h"

const struct LjsGoogleLocationAttributes LjsGoogleLocationAttributes = {
	.latitude100km = @"latitude100km",
	.latitude100m = @"latitude100m",
	.latitude10km = @"latitude10km",
	.latitude10m = @"latitude10m",
	.latitude1km = @"latitude1km",
	.latitude1m = @"latitude1m",
	.latitudeNumber = @"latitudeNumber",
	.longitude100km = @"longitude100km",
	.longitude100m = @"longitude100m",
	.longitude10km = @"longitude10km",
	.longitude10m = @"longitude10m",
	.longitude1km = @"longitude1km",
	.longitude1m = @"longitude1m",
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
	
	if ([key isEqualToString:@"latitude100kmValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude100km"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitude100mValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude100m"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitude10kmValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude10km"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitude10mValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude10m"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitude1kmValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude1km"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitude1mValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude1m"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitudeNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitudeNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitude100kmValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude100km"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitude100mValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude100m"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitude10kmValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude10km"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitude10mValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude10m"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitude1kmValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude1km"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitude1mValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude1m"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitudeNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitudeNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic latitude100km;



- (double)latitude100kmValue {
	NSNumber *result = [self latitude100km];
	return [result doubleValue];
}

- (void)setLatitude100kmValue:(double)value_ {
	[self setLatitude100km:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitude100kmValue {
	NSNumber *result = [self primitiveLatitude100km];
	return [result doubleValue];
}

- (void)setPrimitiveLatitude100kmValue:(double)value_ {
	[self setPrimitiveLatitude100km:[NSNumber numberWithDouble:value_]];
}





@dynamic latitude100m;



- (double)latitude100mValue {
	NSNumber *result = [self latitude100m];
	return [result doubleValue];
}

- (void)setLatitude100mValue:(double)value_ {
	[self setLatitude100m:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitude100mValue {
	NSNumber *result = [self primitiveLatitude100m];
	return [result doubleValue];
}

- (void)setPrimitiveLatitude100mValue:(double)value_ {
	[self setPrimitiveLatitude100m:[NSNumber numberWithDouble:value_]];
}





@dynamic latitude10km;



- (double)latitude10kmValue {
	NSNumber *result = [self latitude10km];
	return [result doubleValue];
}

- (void)setLatitude10kmValue:(double)value_ {
	[self setLatitude10km:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitude10kmValue {
	NSNumber *result = [self primitiveLatitude10km];
	return [result doubleValue];
}

- (void)setPrimitiveLatitude10kmValue:(double)value_ {
	[self setPrimitiveLatitude10km:[NSNumber numberWithDouble:value_]];
}





@dynamic latitude10m;



- (double)latitude10mValue {
	NSNumber *result = [self latitude10m];
	return [result doubleValue];
}

- (void)setLatitude10mValue:(double)value_ {
	[self setLatitude10m:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitude10mValue {
	NSNumber *result = [self primitiveLatitude10m];
	return [result doubleValue];
}

- (void)setPrimitiveLatitude10mValue:(double)value_ {
	[self setPrimitiveLatitude10m:[NSNumber numberWithDouble:value_]];
}





@dynamic latitude1km;



- (double)latitude1kmValue {
	NSNumber *result = [self latitude1km];
	return [result doubleValue];
}

- (void)setLatitude1kmValue:(double)value_ {
	[self setLatitude1km:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitude1kmValue {
	NSNumber *result = [self primitiveLatitude1km];
	return [result doubleValue];
}

- (void)setPrimitiveLatitude1kmValue:(double)value_ {
	[self setPrimitiveLatitude1km:[NSNumber numberWithDouble:value_]];
}





@dynamic latitude1m;



- (double)latitude1mValue {
	NSNumber *result = [self latitude1m];
	return [result doubleValue];
}

- (void)setLatitude1mValue:(double)value_ {
	[self setLatitude1m:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitude1mValue {
	NSNumber *result = [self primitiveLatitude1m];
	return [result doubleValue];
}

- (void)setPrimitiveLatitude1mValue:(double)value_ {
	[self setPrimitiveLatitude1m:[NSNumber numberWithDouble:value_]];
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





@dynamic longitude100km;



- (double)longitude100kmValue {
	NSNumber *result = [self longitude100km];
	return [result doubleValue];
}

- (void)setLongitude100kmValue:(double)value_ {
	[self setLongitude100km:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitude100kmValue {
	NSNumber *result = [self primitiveLongitude100km];
	return [result doubleValue];
}

- (void)setPrimitiveLongitude100kmValue:(double)value_ {
	[self setPrimitiveLongitude100km:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude100m;



- (double)longitude100mValue {
	NSNumber *result = [self longitude100m];
	return [result doubleValue];
}

- (void)setLongitude100mValue:(double)value_ {
	[self setLongitude100m:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitude100mValue {
	NSNumber *result = [self primitiveLongitude100m];
	return [result doubleValue];
}

- (void)setPrimitiveLongitude100mValue:(double)value_ {
	[self setPrimitiveLongitude100m:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude10km;



- (double)longitude10kmValue {
	NSNumber *result = [self longitude10km];
	return [result doubleValue];
}

- (void)setLongitude10kmValue:(double)value_ {
	[self setLongitude10km:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitude10kmValue {
	NSNumber *result = [self primitiveLongitude10km];
	return [result doubleValue];
}

- (void)setPrimitiveLongitude10kmValue:(double)value_ {
	[self setPrimitiveLongitude10km:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude10m;



- (double)longitude10mValue {
	NSNumber *result = [self longitude10m];
	return [result doubleValue];
}

- (void)setLongitude10mValue:(double)value_ {
	[self setLongitude10m:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitude10mValue {
	NSNumber *result = [self primitiveLongitude10m];
	return [result doubleValue];
}

- (void)setPrimitiveLongitude10mValue:(double)value_ {
	[self setPrimitiveLongitude10m:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude1km;



- (double)longitude1kmValue {
	NSNumber *result = [self longitude1km];
	return [result doubleValue];
}

- (void)setLongitude1kmValue:(double)value_ {
	[self setLongitude1km:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitude1kmValue {
	NSNumber *result = [self primitiveLongitude1km];
	return [result doubleValue];
}

- (void)setPrimitiveLongitude1kmValue:(double)value_ {
	[self setPrimitiveLongitude1km:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude1m;



- (double)longitude1mValue {
	NSNumber *result = [self longitude1m];
	return [result doubleValue];
}

- (void)setLongitude1mValue:(double)value_ {
	[self setLongitude1m:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitude1mValue {
	NSNumber *result = [self primitiveLongitude1m];
	return [result doubleValue];
}

- (void)setPrimitiveLongitude1mValue:(double)value_ {
	[self setPrimitiveLongitude1m:[NSNumber numberWithDouble:value_]];
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
