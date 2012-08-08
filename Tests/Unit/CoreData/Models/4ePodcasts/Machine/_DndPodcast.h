// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndPodcast.h instead.

#import <CoreData/CoreData.h>


extern const struct DndPodcastAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *key;
} DndPodcastAttributes;

extern const struct DndPodcastRelationships {
	__unsafe_unretained NSString *players;
} DndPodcastRelationships;

extern const struct DndPodcastFetchedProperties {
} DndPodcastFetchedProperties;

@class DndPlayer;




@interface DndPodcastID : NSManagedObjectID {}
@end

@interface _DndPodcast : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DndPodcastID*)objectID;




@property (nonatomic, strong) NSString* displayName;


//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* key;


//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* players;

- (NSMutableSet*)playersSet;





@end

@interface _DndPodcast (CoreDataGeneratedAccessors)

- (void)addPlayers:(NSSet*)value_;
- (void)removePlayers:(NSSet*)value_;
- (void)addPlayersObject:(DndPlayer*)value_;
- (void)removePlayersObject:(DndPlayer*)value_;

@end

@interface _DndPodcast (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;





- (NSMutableSet*)primitivePlayers;
- (void)setPrimitivePlayers:(NSMutableSet*)value;


@end
