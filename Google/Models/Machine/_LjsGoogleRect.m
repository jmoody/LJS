// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogleRect.m instead.

#import "_LjsGoogleRect.h"

const struct LjsGoogleRectAttributes LjsGoogleRectAttributes = {
	.northeast = @"northeast",
	.southwest = @"southwest",
};

const struct LjsGoogleRectRelationships LjsGoogleRectRelationships = {
};

const struct LjsGoogleRectFetchedProperties LjsGoogleRectFetchedProperties = {
};

@implementation LjsGoogleRectID
@end

@implementation _LjsGoogleRect

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleRect" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogleRect";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogleRect" inManagedObjectContext:moc_];
}

- (LjsGoogleRectID*)objectID {
	return (LjsGoogleRectID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic northeast;






@dynamic southwest;











@end
