// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleThing.m instead.

#import "_LjsGoogleThing.h"

const struct LjsGoogleThingAttributes LjsGoogleThingAttributes = {
	.dateAdded = @"dateAdded",
	.dateModified = @"dateModified",
	.formattedAddress = @"formattedAddress",
	.orderValueNumber = @"orderValueNumber",
};

const struct LjsGoogleThingRelationships LjsGoogleThingRelationships = {
	.locationEnity = @"locationEnity",
};

const struct LjsGoogleThingFetchedProperties LjsGoogleThingFetchedProperties = {
};

@implementation LjsGoogleThingID
@end

@implementation _LjsGoogleThing

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleThing" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleThing";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleThing" inManagedObjectContext:moc_];
}

- (LjsGoogleThingID*)objectID {
	return (LjsGoogleThingID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"orderValueNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"orderValueNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic dateAdded;






@dynamic dateModified;






@dynamic formattedAddress;






@dynamic orderValueNumber;



- (double)orderValueNumberValue {
	NSNumber *result = [self orderValueNumber];
	return [result doubleValue];
}

- (void)setOrderValueNumberValue:(double)value_ {
	[self setOrderValueNumber:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveOrderValueNumberValue {
	NSNumber *result = [self primitiveOrderValueNumber];
	return [result doubleValue];
}

- (void)setPrimitiveOrderValueNumberValue:(double)value_ {
	[self setPrimitiveOrderValueNumber:[NSNumber numberWithDouble:value_]];
}





@dynamic locationEnity;

	






@end
