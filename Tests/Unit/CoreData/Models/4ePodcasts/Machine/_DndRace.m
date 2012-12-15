// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndRace.m instead.

#import "_DndRace.h"

const struct DndRaceAttributes DndRaceAttributes = {
	.displayName = @"displayName",
	.key = @"key",
};

const struct DndRaceRelationships DndRaceRelationships = {
	.characters = @"characters",
};

const struct DndRaceFetchedProperties DndRaceFetchedProperties = {
};

@implementation DndRaceID
@end

@implementation _DndRace

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DndRace" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DndRace";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DndRace" inManagedObjectContext:moc_];
}

- (DndRaceID*)objectID {
	return (DndRaceID*)[super objectID];
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
