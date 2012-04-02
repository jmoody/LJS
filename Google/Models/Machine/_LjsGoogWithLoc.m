// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LjsGoogWithLoc.m instead.

#import "_LjsGoogWithLoc.h"

const struct LjsGoogWithLocAttributes LjsGoogWithLocAttributes = {
};

const struct LjsGoogWithLocRelationships LjsGoogWithLocRelationships = {
	.locationEnity = @"locationEnity",
};

const struct LjsGoogWithLocFetchedProperties LjsGoogWithLocFetchedProperties = {
};

@implementation LjsGoogWithLocID
@end

@implementation _LjsGoogWithLoc

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogWithLoc" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LjsGoogWithLoc";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LjsGoogWithLoc" inManagedObjectContext:moc_];
}

- (LjsGoogWithLocID*)objectID {
	return (LjsGoogWithLocID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic locationEnity;

	






@end
