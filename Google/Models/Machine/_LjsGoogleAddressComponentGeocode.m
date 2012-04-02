// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleAddressComponentGeocode.m instead.

#import "_LjsGoogleAddressComponentGeocode.h"

const struct LjsGoogleAddressComponentGeocodeAttributes LjsGoogleAddressComponentGeocodeAttributes = {
};

const struct LjsGoogleAddressComponentGeocodeRelationships LjsGoogleAddressComponentGeocodeRelationships = {
	.geocode = @"geocode",
};

const struct LjsGoogleAddressComponentGeocodeFetchedProperties LjsGoogleAddressComponentGeocodeFetchedProperties = {
};

@implementation LjsGoogleAddressComponentGeocodeID
@end

@implementation _LjsGoogleAddressComponentGeocode

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleAddressComponentGeocode" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleAddressComponentGeocode";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleAddressComponentGeocode" inManagedObjectContext:moc_];
}

- (LjsGoogleAddressComponentGeocodeID*)objectID {
	return (LjsGoogleAddressComponentGeocodeID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic geocode;

	






@end
