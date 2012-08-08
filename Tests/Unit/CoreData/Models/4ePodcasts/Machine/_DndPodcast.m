// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndPodcast.m instead.

#import "_DndPodcast.h"

const struct DndPodcastAttributes DndPodcastAttributes = {
	.displayName = @"displayName",
	.key = @"key",
};

const struct DndPodcastRelationships DndPodcastRelationships = {
	.players = @"players",
};

const struct DndPodcastFetchedProperties DndPodcastFetchedProperties = {
};

@implementation DndPodcastID
@end

@implementation _DndPodcast

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DndPodcast" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DndPodcast";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DndPodcast" inManagedObjectContext:moc_];
}

- (DndPodcastID*)objectID {
	return (DndPodcastID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic displayName;






@dynamic key;






@dynamic players;

	
- (NSMutableSet*)playersSet {
	[self willAccessValueForKey:@"players"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"players"];
  
	[self didAccessValueForKey:@"players"];
	return result;
}
	






@end
