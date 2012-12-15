// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndPlayer.m instead.

#import "_DndPlayer.h"

const struct DndPlayerAttributes DndPlayerAttributes = {
	.firstName = @"firstName",
	.key = @"key",
};

const struct DndPlayerRelationships DndPlayerRelationships = {
	.characters = @"characters",
	.podcast = @"podcast",
};

const struct DndPlayerFetchedProperties DndPlayerFetchedProperties = {
};

@implementation DndPlayerID
@end

@implementation _DndPlayer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DndPlayer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DndPlayer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DndPlayer" inManagedObjectContext:moc_];
}

- (DndPlayerID*)objectID {
	return (DndPlayerID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic firstName;






@dynamic key;






@dynamic characters;

	
- (NSMutableSet*)charactersSet {
	[self willAccessValueForKey:@"characters"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"characters"];
  
	[self didAccessValueForKey:@"characters"];
	return result;
}
	

@dynamic podcast;

	






@end
