// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndClass.m instead.

#import "_DndClass.h"

const struct DndClassAttributes DndClassAttributes = {
	.displayName = @"displayName",
	.key = @"key",
};

const struct DndClassRelationships DndClassRelationships = {
	.characters = @"characters",
};

const struct DndClassFetchedProperties DndClassFetchedProperties = {
};

@implementation DndClassID
@end

@implementation _DndClass

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DndClass" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DndClass";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DndClass" inManagedObjectContext:moc_];
}

- (DndClassID*)objectID {
	return (DndClassID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic displayName;






@dynamic key;






@dynamic characters;

	
- (NSMutableSet*)charactersSet {
	[self willAccessValueForKey:@"characters"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"characters"];
  
	[self didAccessValueForKey:@"characters"];
	return result;
}
	






@end
