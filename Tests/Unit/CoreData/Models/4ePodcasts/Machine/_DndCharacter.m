// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndCharacter.m instead.

#import "_DndCharacter.h"

const struct DndCharacterAttributes DndCharacterAttributes = {
	.key = @"key",
	.name = @"name",
};

const struct DndCharacterRelationships DndCharacterRelationships = {
	.player = @"player",
	.role = @"role",
};

const struct DndCharacterFetchedProperties DndCharacterFetchedProperties = {
};

@implementation DndCharacterID
@end

@implementation _DndCharacter

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DndCharacter" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DndCharacter";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DndCharacter" inManagedObjectContext:moc_];
}

- (DndCharacterID*)objectID {
	return (DndCharacterID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic key;






@dynamic name;






@dynamic player;

	

@dynamic role;

	






@end
