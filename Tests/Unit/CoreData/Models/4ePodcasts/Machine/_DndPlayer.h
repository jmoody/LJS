// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndPlayer.h instead.

#import <CoreData/CoreData.h>


extern const struct DndPlayerAttributes {
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *key;
} DndPlayerAttributes;

extern const struct DndPlayerRelationships {
	__unsafe_unretained NSString *characters;
	__unsafe_unretained NSString *podcast;
} DndPlayerRelationships;

extern const struct DndPlayerFetchedProperties {
} DndPlayerFetchedProperties;

@class DndCharacter;
@class DndPodcast;




@interface DndPlayerID : NSManagedObjectID {}
@end

@interface _DndPlayer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DndPlayerID*)objectID;




@property (nonatomic, strong) NSString* firstName;


//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* key;


//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* characters;

- (NSMutableSet*)charactersSet;




@property (nonatomic, strong) DndPodcast* podcast;

//- (BOOL)validatePodcast:(id*)value_ error:(NSError**)error_;





@end

@interface _DndPlayer (CoreDataGeneratedAccessors)

- (void)addCharacters:(NSSet*)value_;
- (void)removeCharacters:(NSSet*)value_;
- (void)addCharactersObject:(DndCharacter*)value_;
- (void)removeCharactersObject:(DndCharacter*)value_;

@end

@interface _DndPlayer (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;





- (NSMutableSet*)primitiveCharacters;
- (void)setPrimitiveCharacters:(NSMutableSet*)value;



- (DndPodcast*)primitivePodcast;
- (void)setPrimitivePodcast:(DndPodcast*)value;


@end
