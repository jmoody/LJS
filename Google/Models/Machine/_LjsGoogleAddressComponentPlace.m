// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAddressComponentPlace.m instead.

#import "_LjsGoogleAddressComponentPlace.h"

const struct LjsGoogleAddressComponentPlaceAttributes LjsGoogleAddressComponentPlaceAttributes = {
};

const struct LjsGoogleAddressComponentPlaceRelationships LjsGoogleAddressComponentPlaceRelationships = {
	.place = @"place",
};

const struct LjsGoogleAddressComponentPlaceFetchedProperties LjsGoogleAddressComponentPlaceFetchedProperties = {
};

@implementation LjsGoogleAddressComponentPlaceID
@end

@implementation _LjsGoogleAddressComponentPlace

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleAddressComponentPlace" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleAddressComponentPlace";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleAddressComponentPlace" inManagedObjectContext:moc_];
}

- (LjsGoogleAddressComponentPlaceID*)objectID {
	return (LjsGoogleAddressComponentPlaceID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic place;

	






@end
