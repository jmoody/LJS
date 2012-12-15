// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DndCharacter.h instead.

#import <CoreData/CoreData.h>


extern const struct DndCharacterAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *name;
} DndCharacterAttributes;

extern const struct DndCharacterRelationships {
	__unsafe_unretained NSString *charClass;
	__unsafe_unretained NSString *player;
	__unsafe_unretained NSString *race;
	__unsafe_unretained NSString *role;
} DndCharacterRelationships;

extern const struct DndCharacterFetchedProperties {
} DndCharacterFetchedProperties;

@class DndClass;
@class DndPlayer;
@class DndRace;
@class DndRole;




@interface DndCharacterID : NSManagedObjectID {}
@end

@interface _DndCharacter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DndCharacterID*)objectID;




@property (nonatomic, strong) NSString* key;


//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) DndClass* charClass;

//- (BOOL)validateCharClass:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) DndPlayer* player;

//- (BOOL)validatePlayer:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) DndRace* race;

//- (BOOL)validateRace:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) DndRole* role;

//- (BOOL)validateRole:(id*)value_ error:(NSError**)error_;





@end

@interface _DndCharacter (CoreDataGeneratedAccessors)

@end

@interface _DndCharacter (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (DndClass*)primitiveCharClass;
- (void)setPrimitiveCharClass:(DndClass*)value;



- (DndPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(DndPlayer*)value;



- (DndRace*)primitiveRace;
- (void)setPrimitiveRace:(DndRace*)value;



- (DndRole*)primitiveRole;
- (void)setPrimitiveRole:(DndRole*)value;


@end
