// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndRole.m instead.

#import "_DndRole.h"

const struct DndRoleAttributes DndRoleAttributes = {
	.displayName = @"displayName",
	.key = @"key",
};

const struct DndRoleRelationships DndRoleRelationships = {
	.characters = @"characters",
};

const struct DndRoleFetchedProperties DndRoleFetchedProperties = {
};

@implementation DndRoleID
@end

@implementation _DndRole

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DndRole" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DndRole";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DndRole" inManagedObjectContext:moc_];
}

- (DndRoleID*)objectID {
	return (DndRoleID*)[super objectID];
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
