// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndRace.h instead.

#import <CoreData/CoreData.h>


extern const struct DndRaceAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *key;
} DndRaceAttributes;

extern const struct DndRaceRelationships {
	__unsafe_unretained NSString *characters;
} DndRaceRelationships;

extern const struct DndRaceFetchedProperties {
} DndRaceFetchedProperties;

@class DndCharacter;




@interface DndRaceID : NSManagedObjectID {}
@end

@interface _DndRace : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DndRaceID*)objectID;




@property (nonatomic, strong) NSString* displayName;


//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* key;


//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* characters;

- (NSMutableSet*)charactersSet;





@end

@interface _DndRace (CoreDataGeneratedAccessors)

- (void)addCharacters:(NSSet*)value_;
- (void)removeCharacters:(NSSet*)value_;
- (void)addCharactersObject:(DndCharacter*)value_;
- (void)removeCharactersObject:(DndCharacter*)value_;

@end

@interface _DndRace (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;





- (NSMutableSet*)primitiveCharacters;
- (void)setPrimitiveCharacters:(NSMutableSet*)value;


@end
