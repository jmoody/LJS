// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleLocation.m instead.

#import "_LjsGoogleLocation.h"

const struct LjsGoogleLocationAttributes LjsGoogleLocationAttributes = {
	.latitude = @"latitude",
	.latitude100km = @"latitude100km",
	.latitude100m = @"latitude100m",
	.latitude10km = @"latitude10km",
	.latitude10m = @"latitude10m",
	.latitude1km = @"latitude1km",
	.latitude1m = @"latitude1m",
	.longitude = @"longitude",
	.longitude100km = @"longitude100km",
	.longitude100m = @"longitude100m",
	.longitude10km = @"longitude10km",
	.longitude10m = @"longitude10m",
	.longitude1km = @"longitude1km",
	.longitude1m = @"longitude1m",
	.type = @"type",
};

const struct LjsGoogleLocationRelationships LjsGoogleLocationRelationships = {
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
	

	return keyPaths;
}




@dynamic latitude;






@dynamic latitude100km;






@dynamic latitude100m;






@dynamic latitude10km;






@dynamic latitude10m;






@dynamic latitude1km;






@dynamic latitude1m;






@dynamic longitude;






@dynamic longitude100km;






@dynamic longitude100m;






@dynamic longitude10km;






@dynamic longitude10m;






@dynamic longitude1km;






@dynamic longitude1m;






@dynamic type;











@end
