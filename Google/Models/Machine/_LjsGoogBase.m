// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogBase.m instead.

#import "_LjsGoogBase.h"

const struct LjsGoogBaseAttributes LjsGoogBaseAttributes = {
	.dateAdded = @"dateAdded",
	.dateModified = @"dateModified",
	.formattedAddress = @"formattedAddress",
};

const struct LjsGoogBaseRelationships LjsGoogBaseRelationships = {
};

const struct LjsGoogBaseFetchedProperties LjsGoogBaseFetchedProperties = {
};

@implementation LjsGoogBaseID
@end

@implementation _LjsGoogBase

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogBase" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogBase";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogBase" inManagedObjectContext:moc_];
}

- (LjsGoogBaseID*)objectID {
	return (LjsGoogBaseID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic dateAdded;






@dynamic dateModified;






@dynamic formattedAddress;











@end
